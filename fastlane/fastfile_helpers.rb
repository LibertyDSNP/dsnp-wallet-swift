 
def fastfile_dir
File.expand_path(__dir__)
end

def project_path
return File.expand_path("#{fastfile_dir}/..")
end

def derived_data_path
"#{project_path}/derived_data/iOS/"
end

def output_path
"#{project_path}/output"
end

def scan_output_path
"#{output_path}"
end
