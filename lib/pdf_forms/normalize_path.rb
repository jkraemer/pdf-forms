# coding: UTF-8

module PdfForms

  module NormalizePath

    def normalize_path(path)
      Pathname(path).to_path
    end

  end

end
