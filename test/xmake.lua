add_rules("mode.release")

add_requires("nlohmann_json master")

set_languages("cxx20")
set_warnings("all", "error")

target("xmake-inja-test-packfile")
    set_kind("phony")
    before_build(function (target)
        import("core.base.task")
        task.run("inja", {
            template = path.join(os.scriptdir(),"json.h.tmpl"),
            jsondata = format([[{
                "use_string_view" : true, 
                "variable_name" : "json_data",
                "data" : "%s"
            }]], io.readfile(path.join(os.scriptdir(),"test.json")):gsub("(\n)", "\\n"):gsub("(\")", "\\\"")),
            ouput = path.join(os.scriptdir(),"json.h"),
            format = true,
        })
    end)
target_end()

target("xmake-inja-test")
    set_kind("binary")
    add_files("*.cc")
    add_packages("nlohmann_json")
    add_deps("xmake-inja-test-packfile")