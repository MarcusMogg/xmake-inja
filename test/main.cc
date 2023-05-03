#include <iostream>

#include "json.h"
#include "nlohmann/json.hpp"


int main() {
  auto j = nlohmann::json::parse(json_data);
  std::cout << j.size();
  return 0;
}