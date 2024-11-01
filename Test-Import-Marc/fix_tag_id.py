from lxml import etree

# Đường dẫn đến file .marcxml của bạn
input_file = r"D:\GRPR (Graduation Project)\Documents\Test-Import-Marc\marcxml_2024.marcxml"
output_file = r"D:\GRPR (Graduation Project)\Documents\Test-Import-Marc\[tag-edited]marcxml_2024.marcxml"

# Đọc file .marcxml
tree = etree.parse(input_file)
root = tree.getroot()

# Namespace cho file MARC21
namespace = "http://www.loc.gov/MARC21/slim"
nsmap = {"marc": namespace}

# Đếm và thêm tag 001 sau thẻ leader cho từng record
record_id = 1
for record in root.findall('.//marc:record', namespaces=nsmap):
    # Tạo thẻ controlfield mới với tag 001
    controlfield_001 = etree.Element("{%s}controlfield" % namespace, tag="001")
    controlfield_001.text = str(record_id)
    
    # Tìm thẻ leader và chèn thẻ 001 ngay sau nó
    leader = record.find('marc:leader', namespaces=nsmap)
    if leader is not None:
        record.insert(record.index(leader) + 1, controlfield_001)
    else:
        # Nếu không tìm thấy thẻ leader, thêm thẻ 001 vào đầu record
        record.insert(0, controlfield_001)
    
    record_id += 1

# Chuyển đổi toàn bộ cây XML thành chuỗi, sử dụng pretty_print=True để làm đẹp
xml_string = etree.tostring(root, pretty_print=True, xml_declaration=True, encoding="UTF-8").decode("UTF-8")

# Đảm bảo mỗi <controlfield> nằm trên một dòng riêng và thụt đúng vào 2 lần
xml_string = xml_string.replace("><controlfield", ">\n    <controlfield")

# Ghi chuỗi đã xử lý vào file
with open(output_file, "w", encoding="UTF-8") as f:
    f.write(xml_string)

print(f"Tag 001 đã được thêm vào sau mỗi leader trong {output_file}, và mỗi <controlfield> nằm trên dòng riêng với thụt đúng 2 lần.")
