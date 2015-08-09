# coding: UTF-8

module PdfForms

  module NormalizePath

    def normalize_path(path)
      path = path.to_path if path.respond_to? :to_path
      path.to_str
    end

  end

end
