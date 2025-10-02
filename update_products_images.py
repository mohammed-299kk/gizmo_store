import requests
import json

# إعدادات Firebase
FIREBASE_PROJECT_ID = "gizmo-store"
FIREBASE_API_KEY = "AIzaSyBqJJ5J5J5J5J5J5J5J5J5J5J5J5J5J5J5"  # استخدم المفتاح الصحيح
FIRESTORE_BASE_URL = f"https://firestore.googleapis.com/v1/projects/{FIREBASE_PROJECT_ID}/databases/(default)/documents"

# قراءة ملف figma-design
def read_figma_design():
    with open('figma-design', 'r', encoding='utf-8') as file:
        content = file.read()
    return content

# استخراج الصور من المحتوى
def extract_product_images(content):
    lines = content.strip().split('\n')
    products_images = {}
    
    current_category = None
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
            
        # تحديد الفئة
        if 'سماعات' in line or 'Headphones' in line:
            current_category = 'headphones'
        elif 'لاب توب' in line or 'Laptop' in line:
            current_category = 'laptop'
        elif 'هواتف' in line or 'Phone' in line:
            current_category = 'phone'
        elif 'تابلت' in line or 'Tablet' in line:
            current_category = 'tablet'
        elif 'ساعات' in line or 'Watch' in line:
            current_category = 'watch'
        elif 'أجهزة تلفاز' in line or 'TV' in line:
            current_category = 'tv'
        elif line.startswith('http'):
            # هذا رابط صورة
            if current_category:
                if current_category not in products_images:
                    products_images[current_category] = []
                products_images[current_category].append(line)
    
    return products_images

# الحصول على جميع المنتجات من Firebase
def get_all_products():
    try:
        response = requests.get(f"{FIRESTORE_BASE_URL}/products")
        if response.status_code == 200:
            data = response.json()
            products = []
            if 'documents' in data:
                for doc in data['documents']:
                    doc_id = doc['name'].split('/')[-1]
                    fields = doc.get('fields', {})
                    product = {'id': doc_id}
                    for key, value in fields.items():
                        if 'stringValue' in value:
                            product[key] = value['stringValue']
                        elif 'doubleValue' in value:
                            product[key] = float(value['doubleValue'])
                        elif 'integerValue' in value:
                            product[key] = int(value['integerValue'])
                    products.append(product)
            return products
        else:
            print(f"خطأ في الحصول على المنتجات: {response.status_code}")
            return []
    except Exception as e:
        print(f"خطأ في الاتصال بـ Firebase: {e}")
        return []

# تحديث منتج واحد
def update_product(product_id, new_image):
    try:
        update_data = {
            "fields": {
                "image": {
                    "stringValue": new_image
                }
            }
        }
        
        response = requests.patch(
            f"{FIRESTORE_BASE_URL}/products/{product_id}",
            json=update_data,
            params={"updateMask.fieldPaths": "image"}
        )
        
        if response.status_code == 200:
            return True
        else:
            print(f"خطأ في تحديث المنتج {product_id}: {response.status_code}")
            return False
    except Exception as e:
        print(f"خطأ في تحديث المنتج {product_id}: {e}")
        return False

# تحديث المنتجات بالصور الجديدة
def update_products_with_new_images():
    content = read_figma_design()
    product_images = extract_product_images(content)
    
    print("الصور المستخرجة:")
    for category, images in product_images.items():
        print(f"{category}: {len(images)} صورة")
    
    # الحصول على جميع المنتجات
    products = get_all_products()
    print(f"\nتم العثور على {len(products)} منتج في Firebase")
    
    updated_count = 0
    
    for product in products:
        product_name = product.get('name', '').lower()
        current_image = product.get('image', '')
        
        # تحديد الفئة بناءً على اسم المنتج
        new_image = None
        
        if 'airpods' in product_name or 'headphone' in product_name:
            if 'headphones' in product_images and product_images['headphones']:
                new_image = product_images['headphones'][0]
                product_images['headphones'].pop(0)
        elif 'macbook' in product_name or 'laptop' in product_name:
            if 'laptop' in product_images and product_images['laptop']:
                new_image = product_images['laptop'][0]
                product_images['laptop'].pop(0)
        elif 'iphone' in product_name or 'phone' in product_name:
            if 'phone' in product_images and product_images['phone']:
                new_image = product_images['phone'][0]
                product_images['phone'].pop(0)
        elif 'ipad' in product_name or 'tablet' in product_name:
            if 'tablet' in product_images and product_images['tablet']:
                new_image = product_images['tablet'][0]
                product_images['tablet'].pop(0)
        elif 'watch' in product_name:
            if 'watch' in product_images and product_images['watch']:
                new_image = product_images['watch'][0]
                product_images['watch'].pop(0)
        elif 'tv' in product_name or 'samsung' in product_name:
            if 'tv' in product_images and product_images['tv']:
                new_image = product_images['tv'][0]
                product_images['tv'].pop(0)
        
        # تحديث الصورة إذا وُجدت صورة جديدة
        if new_image and new_image != current_image:
            if update_product(product['id'], new_image):
                print(f"تم تحديث صورة المنتج: {product.get('name')} -> {new_image}")
                updated_count += 1
            else:
                print(f"فشل في تحديث المنتج: {product.get('name')}")
    
    print(f"\nتم تحديث {updated_count} منتج بصور جديدة")
    return updated_count

if __name__ == "__main__":
    print("بدء تحديث صور المنتجات...")
    updated_count = update_products_with_new_images()
    print(f"انتهى التحديث. تم تحديث {updated_count} منتج.")