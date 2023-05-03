includes("lib")
includes("test")

task("inja")
    set_category("plugin")
    on_run("main")
    set_menu {
        usage = "xmake inja [options]",
        description = "generate file by inja",
        options = {
            {'f', "format", "k", false, "run clang-format after gen"},
            {'t', "template", "kv", nil, "template file path"},
            {'-', "jsonfile", "kv", nil, "data file path (*.json)"},
            {'-', "jsondata", "kv", nil, "json data"},
            {},
            {nil, "ouput", "v", nil, "output file path"},
        },
    }

