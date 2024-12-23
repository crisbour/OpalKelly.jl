#Constant parameters
@static if Sys.islinux()
    base_path=string(dirname(Base.source_path()),"/../lib/")
    const ok_front_panel_lib_path = string(base_path,"Linux/libokFrontPanel.so")
    #ok_front_panel_lib = Libdl.dlopen(ok_front_panel_lib_path,Libdl.RTLD_NOW)
end

@static if Sys.isapple()
    base_path=string(dirname(Base.source_path()),"/../lib/")
    const ok_front_panel_lib_path = string(base_path,"Mac/libokFrontPanel.dylib")
end

@static if Sys.iswindows()
    base_path=string(dirname(Base.source_path()),"\\..\\lib\\")
    const ok_front_panel_lib_path = string(base_path,"Windows/okFrontPanel.dll")
end
