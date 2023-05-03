import("core.base.option")
import("core.base.task")
import("core.project.rule")
import("core.project.config")
import("core.project.project")
import("core.tool.compiler")
import("lib.detect")

function GetProgram(target_name, lazy_build, pathes)
    if lazy_build then
        local program = detect.find_program(target_name,{pathes = pathes})
        if program ~= nil then
            return program
        end
        print(format("can't find program %s",target_name))
    end 
    project.lock()
    task.run("build", {target = target_name, all = false})
    project.unlock()

    local program = detect.find_program(target_name,{pathes = pathes})
    if program == nil then
        raise(format("can't build & find %s", target_name))
    end
    
    return program
end

function GetTargetDir(name) 
    return path.join(os.projectdir(),"lcsrc");
end 

function GetTmplDir() 
    return path.join(os.scriptdir(),"template");
end 

function GetForce(force) 
    if force then
        return "--force"
    end
    return ""
end

function main()
    local out_path = option.get("ouput")
    if out_path == nil then
        raise("can't find ouput path")
    end

    local template_path = option.get("template")
    if template_path == nil then
        raise("can't find template path")
    end

    local json_path = option.get("jsonfile")
    local json_data = option.get("jsondata")
    if json_data ~= nil then
        json_path = os.tmpfile()
        io.writefile(json_path, json_data)
    end
    local format_v = option.get("format") or false

    local inja = GetProgram("xmake-inja", true, {path.join(os.scriptdir(),"lib")})
    local params=  {
        "-t", template_path,
        "-o", out_path,
        format([[--jsonfile=%s]],json_path),
    }
    os.execv(inja, params)

    if format_v then
        task.run("format",{files = path.relative(out_path)})
    end
end