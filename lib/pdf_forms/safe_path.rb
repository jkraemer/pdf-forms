# coding: UTF-8

module PdfForms

  module SafePath

    def normalize_path(path)
      fpath = file_path(path)
      quote_path(fpath)
    end

    alias :safe_path :normalize_path

    def quote_path(path)
      %Q("#{path}")
    end

    def file_path(path)
      path = path.to_path if path.respond_to? :to_path
      path.to_str
    end
  end

end
