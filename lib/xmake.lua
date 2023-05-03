add_rules("mode.release")

add_requires("inja 3.4.0")
add_requires("argparse master")
add_requires("nlohmann_json master")

set_languages("cxx20")
set_warnings("all", "error")

target("xmake-inja")
    set_kind("binary")
    add_files("*.cc")
    add_packages("argparse","nlohmann_json","inja")
    after_build(function (target)
        import("core.project.config")
        local targetfile = target:targetfile()
        os.cp(targetfile, os.scriptdir())
    end)
