module EasyXML
  module_function

  def attribute_value(file_path, xpath, attribute_name)
    xml_document = read_document(file_path)
    xml_document.at_xpath(xpath)[attribute_name]
  end

  def assign_attribute_value(file_path, xpath, attribute_name, attribute_value)
    xml_document = read_document(file_path)
    raise "No node exists at xpath: #{xpath}" if xml_document.at_xpath(xpath).nil?
    return if xml_document.at_xpath(xpath)[attribute_name] == attribute_value
    xml_document.at_xpath(xpath)[attribute_name] = attribute_value
    File.write(file_path, xml_document.to_xml)
  end

  def read_document(file_path)
    Nokogiri::XML(::File.read(file_path))
  end

  def add_element(file_path, xpath, element_text, allow_duplicates: false)
    xml_document = read_document(file_path)
    parent_xpath = ::File.dirname(xpath)
    element_name = ::File.basename(xpath)
    return unless allow_duplicates || !element_exists?(xml_document, xpath)
    xml_document.at_xpath(parent_xpath).add_child("<#{element_name}>#{element_text}</#{element_name}>")
    File.write(file_path, xml_document.to_xml)
  end

  def element_exists?(xml_document, xpath)
    !!xml_document.at_xpath(xpath)
  end
end
