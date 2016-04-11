module CDNJS
  module ViewHelpers
    def cdnjs_include_tag(cdn_vars=nil)
      cdn_vars       ||= Rails.application.config.cdnjs
      js_string_output = Array.new

      cdn_vars.each do |js_file_config|
        window_var = js_file_config.fetch(:windowvar)
        split_vars = window_var.split(".")
        window_path = ""

        split_vars.each_with_index do |val, index|
          var_check = ["window"]

          0.upto(index) do |i|
            var_check.push split_vars[i]
          end

          window_path << var_check.join(".") + " && "
        end

        window_path.chomp!(" && ")

        # js_string_output << javascript_tag("(#{window_path}) || document.write(unescape(\"%3Cscript src='#{asset_path(js_file_config.fetch(:localpath)).gsub('<','%3C')}' type='text/javascript'%3E%3C/script%3E\"))")
        if Rails.env.production?
          js_string_output << javascript_include_tag("//cdnjs.cloudflare.com/ajax/libs/#{js_file_config.fetch(:cdnjs)}")
        else
          js_string_output << javascript_tag("document.write(unescape(\"%3Cscript src='#{asset_path(js_file_config.fetch(:localpath)).gsub('<','%3C')}' type='text/javascript'%3E%3C/script%3E\"))")
        end

      end

      js_string_output.join("\n").html_safe
    end
  end
end

