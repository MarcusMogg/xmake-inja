#include <filesystem>
#include <fstream>
#include <memory>

#include "argparse/argparse.hpp"
#include "inja/inja.hpp"
#include "nlohmann/json.hpp"

std::shared_ptr<argparse::ArgumentParser> PrepareParser() {
  auto parser = std::make_shared<argparse::ArgumentParser>("inja");
  parser->add_argument("-o").help("output path").required();
  parser->add_argument("-t").help("template file path").required();

  parser->add_argument("--jsonfile").help("json data file path");
  parser->add_argument("--jsondata").help("json data file path");

  return parser;
}

std::filesystem::path GetOutputPath(const std::shared_ptr<argparse::ArgumentParser>& parser) {
  return parser->get("-o");
}

std::filesystem::path GetTemplatePath(const std::shared_ptr<argparse::ArgumentParser>& parser) {
  return parser->get("-t");
}

nlohmann::json GetData(const std::shared_ptr<argparse::ArgumentParser>& parser) {
  nlohmann::json res;

  if (parser->is_used("--jsondata")) {
    res = nlohmann::json::parse(parser->get("--jsondata"));
  }

  if (parser->is_used("--jsonfile")) {
    std::ifstream i(parser->get("--jsonfile"));
    i >> res;
  }

  return res;
}

int main(int argc, const char** argv) {
  try {
    auto parser = PrepareParser();
    parser->parse_args(argc, argv);

    const auto out_path = GetOutputPath(parser);
    if (std::filesystem::is_directory(out_path)) {
      std::cout << out_path << "not a file\n";
      return 1;
    }
    if (!std::filesystem::exists(out_path.parent_path())) {
      std::filesystem::create_directories(out_path.parent_path());
    }

    inja::Environment env;
    env.write(GetTemplatePath(parser).string(), GetData(parser), out_path.string());
  } catch (const std::runtime_error& e) {
    std::cout << e.what() << "\n";
  }
  return 0;
}