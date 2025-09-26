

الملف الرئيسي - `/App.tsx`
```tsx
import CategoryBasedProductForm from './components/CategoryBasedProductForm';

export default function App() {
  return (
    <div className="min-h-screen bg-background">
      <CategoryBasedProductForm />
    </div>
  );
}
```

مكون النموذج الرئيسي - `/components/CategoryBasedProductForm.tsx`
```tsx
import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Textarea } from './ui/textarea';
import { Button } from './ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Badge } from './ui/badge';
import { Separator } from './ui/separator';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { 
  Upload, X, Plus, Package, Tag, 
  Smartphone, Laptop, Headphones, Tablet, Watch, 
  Cpu, Camera, Battery, Monitor, HardDrive, Speaker,
  Wifi, Bluetooth, Usb, Clock, Heart, Gamepad2
} from 'lucide-react';

// تعريف أنواع الفئات المختلفة
interface CategoryField {
  key: string;
  label: string;
  type: 'input' | 'select' | 'textarea';
  options?: { value: string; label: string }[];
  placeholder?: string;
  icon?: React.ReactNode;
  required?: boolean;
}

interface ProductCategory {
  id: string;
  name: string;
  icon: React.ReactNode;
  fields: CategoryField[];
  defaultImage: string;
}

// تعريف الفئات والمواصفات المخصصة لكل فئة
const productCategories: ProductCategory[] = [
  {
    id: 'smartphones',
    name: 'الهواتف الذكية',
    icon: <Smartphone className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'processor', label: 'المعالج', type: 'input', placeholder: 'A17 Pro', icon: <Cpu className="w-4 h-4" />, required: true },
      { key: 'ram', label: 'ذاكرة التشغيل', type: 'select', icon: <HardDrive className="w-4 h-4" />, options: [
        { value: '4gb', label: '4 جيجابايت' },
        { value: '6gb', label: '6 جيجابايت' },
        { value: '8gb', label: '8 جيجابايت' },
        { value: '12gb', label: '12 جيجابايت' },
        { value: '16gb', label: '16 جيجابايت' }
      ]},
      { key: 'storage', label: 'مساحة التخزين', type: 'select', options: [
        { value: '64gb', label: '64 جيجابايت' },
        { value: '128gb', label: '128 جيجابايت' },
        { value: '256gb', label: '256 جيجابايت' },
        { value: '512gb', label: '512 جيجابايت' },
        { value: '1tb', label: '1 تيرابايت' }
      ]},
      { key: 'display', label: 'الشاشة', type: 'input', placeholder: '6.7 بوصة OLED', icon: <Monitor className="w-4 h-4" /> },
      { key: 'camera', label: 'الكاميرا', type: 'input', placeholder: '48 ميجابكسل ثلاثية', icon: <Camera className="w-4 h-4" /> },
      { key: 'battery', label: 'البطارية', type: 'input', placeholder: '4422 مللي أمبير', icon: <Battery className="w-4 h-4" /> },
      { key: 'os', label: 'نظام التشغيل', type: 'select', options: [
        { value: 'ios', label: 'iOS' },
        { value: 'android', label: 'Android' },
        { value: 'harmonyos', label: 'HarmonyOS' }
      ]},
      { key: 'network', label: 'شبكة الاتصال', type: 'select', options: [
        { value: '4g', label: '4G LTE' },
        { value: '5g', label: '5G' }
      ]}
    ]
  },
  {
    id: 'laptops',
    name: 'أجهزة اللابتوب',
    icon: <Laptop className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1737868131581-6379cdee4ec3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsYXB0b3AlMjBjb21wdXRlciUyMHRlY2hub2xvZ3l8ZW58MXx8fHwxNzU4MzQxMDI4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'processor', label: 'المعالج', type: 'input', placeholder: 'Intel Core i7-13700H', icon: <Cpu className="w-4 h-4" />, required: true },
      { key: 'ram', label: 'ذاكرة التشغيل', type: 'select', icon: <HardDrive className="w-4 h-4" />, options: [
        { value: '8gb', label: '8 جيجابايت' },
        { value: '16gb', label: '16 جيجابايت' },
        { value: '32gb', label: '32 جيجابايت' },
        { value: '64gb', label: '64 جيجابايت' }
      ]},
      { key: 'storage', label: 'التخزين', type: 'select', options: [
        { value: '256gb', label: '256 جيجابايت SSD' },
        { value: '512gb', label: '512 جيجابايت SSD' },
        { value: '1tb', label: '1 تيرابايت SSD' },
        { value: '2tb', label: '2 تيرابايت SSD' }
      ]},
      { key: 'display', label: 'الشاشة', type: 'input', placeholder: '15.6 بوصة FHD', icon: <Monitor className="w-4 h-4" /> },
      { key: 'graphics', label: 'كرت الرسومات', type: 'input', placeholder: 'NVIDIA RTX 4070' },
      { key: 'os', label: 'نظام التشغيل', type: 'select', options: [
        { value: 'windows11', label: 'Windows 11' },
        { value: 'macos', label: 'macOS' },
        { value: 'linux', label: 'Linux' }
      ]},
      { key: 'weight', label: 'الوزن', type: 'input', placeholder: '2.1 كيلوجرام' },
      { key: 'ports', label: 'المنافذ', type: 'textarea', placeholder: 'USB-C, USB 3.0, HDMI, Audio Jack' }
    ]
  },
  {
    id: 'headphones',
    name: 'سماعات الرأس',
    icon: <Headphones className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1632200004922-bc18602c79fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWFkcGhvbmVzJTIwd2lyZWxlc3MlMjBhdWRpb3xlbnwxfHx8fDE3NTgyOTY1NDJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'type', label: 'النوع', type: 'select', options: [
        { value: 'wireless', label: 'لاسلكية' },
        { value: 'wired', label: 'سلكية' },
        { value: 'true-wireless', label: 'لاسلكية بالكامل' }
      ], required: true },
      { key: 'driver_size', label: 'حجم السائق', type: 'input', placeholder: '40mm', icon: <Speaker className="w-4 h-4" /> },
      { key: 'frequency_response', label: 'نطاق التردد', type: 'input', placeholder: '20Hz - 20kHz' },
      { key: 'impedance', label: 'المقاومة', type: 'input', placeholder: '32 Ohm' },
      { key: 'battery_life', label: 'عمر البطارية', type: 'input', placeholder: '30 ساعة', icon: <Battery className="w-4 h-4" /> },
      { key: 'noise_cancellation', label: 'إلغاء الضوضاء', type: 'select', options: [
        { value: 'active', label: 'إلغاء نشط' },
        { value: 'passive', label: 'إلغاء سلبي' },
        { value: 'none', label: 'بدون إلغاء' }
      ]},
      { key: 'connectivity', label: 'الاتصال', type: 'select', icon: <Bluetooth className="w-4 h-4" />, options: [
        { value: 'bluetooth5', label: 'Bluetooth 5.0' },
        { value: 'bluetooth52', label: 'Bluetooth 5.2' },
        { value: 'bluetooth53', label: 'Bluetooth 5.3' },
        { value: 'wired', label: 'سلكي فقط' }
      ]},
      { key: 'microphone', label: 'الميكروفون', type: 'select', options: [
        { value: 'built-in', label: 'مدمج' },
        { value: 'detachable', label: 'قابل للفصل' },
        { value: 'none', label: 'بدون ميكروفون' }
      ]}
    ]
  },
  {
    id: 'tablets',
    name: 'الأجهزة اللوحية',
    icon: <Tablet className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1630042461973-179ca2cfa7bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0YWJsZXQlMjBkZXZpY2UlMjB0ZWNobm9sb2d5fGVufDF8fHx8MTc1ODI1MTczNHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'processor', label: 'المعالج', type: 'input', placeholder: 'M2 Chip', icon: <Cpu className="w-4 h-4" />, required: true },
      { key: 'ram', label: 'ذاكرة التشغيل', type: 'select', icon: <HardDrive className="w-4 h-4" />, options: [
        { value: '4gb', label: '4 جيجابايت' },
        { value: '6gb', label: '6 جيجابايت' },
        { value: '8gb', label: '8 جيجابايت' },
        { value: '16gb', label: '16 جيجابايت' }
      ]},
      { key: 'storage', label: 'مساحة التخزين', type: 'select', options: [
        { value: '64gb', label: '64 جيجابايت' },
        { value: '128gb', label: '128 جيجابايت' },
        { value: '256gb', label: '256 جيجابايت' },
        { value: '512gb', label: '512 جيجابايت' },
        { value: '1tb', label: '1 تيرابايت' }
      ]},
      { key: 'display', label: 'الشاشة', type: 'input', placeholder: '10.9 بوصة Liquid Retina', icon: <Monitor className="w-4 h-4" /> },
      { key: 'camera', label: 'الكاميرا', type: 'input', placeholder: '12 ميجابكسل خلفية', icon: <Camera className="w-4 h-4" /> },
      { key: 'battery_life', label: 'عمر البطارية', type: 'input', placeholder: '10 ساعات', icon: <Battery className="w-4 h-4" /> },
      { key: 'connectivity', label: 'الاتصال', type: 'select', icon: <Wifi className="w-4 h-4" />, options: [
        { value: 'wifi', label: 'Wi-Fi فقط' },
        { value: 'cellular', label: 'Wi-Fi + Cellular' }
      ]},
      { key: 'os', label: 'نظام التشغيل', type: 'select', options: [
        { value: 'ipados', label: 'iPadOS' },
        { value: 'android', label: 'Android' },
        { value: 'windows', label: 'Windows' }
      ]}
    ]
  },
  {
    id: 'smartwatches',
    name: 'الساعات الذكية',
    icon: <Watch className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'display', label: 'الشاشة', type: 'input', placeholder: '1.9 بوصة AMOLED', icon: <Monitor className="w-4 h-4" />, required: true },
      { key: 'battery_life', label: 'عمر البطارية', type: 'input', placeholder: '7 أيام', icon: <Battery className="w-4 h-4" /> },
      { key: 'water_resistance', label: 'مقاومة الماء', type: 'select', options: [
        { value: 'ip67', label: 'IP67' },
        { value: 'ip68', label: 'IP68' },
        { value: '5atm', label: '5ATM' },
        { value: '10atm', label: '10ATM' }
      ]},
      { key: 'health_sensors', label: 'أجهزة الاستشعار الصحية', type: 'textarea', placeholder: 'مراقب نبضات القلب، أكسجين الدم، النوم', icon: <Heart className="w-4 h-4" /> },
      { key: 'connectivity', label: 'الاتصال', type: 'select', icon: <Bluetooth className="w-4 h-4" />, options: [
        { value: 'bluetooth', label: 'Bluetooth' },
        { value: 'wifi', label: 'Wi-Fi + Bluetooth' },
        { value: 'cellular', label: 'Cellular + Wi-Fi + Bluetooth' }
      ]},
      { key: 'compatibility', label: 'التوافق', type: 'select', options: [
        { value: 'ios', label: 'iOS فقط' },
        { value: 'android', label: 'Android فقط' },
        { value: 'both', label: 'iOS و Android' }
      ]},
      { key: 'case_material', label: 'مادة العلبة', type: 'input', placeholder: 'ألومنيوم' },
      { key: 'band_material', label: 'مادة السوار', type: 'input', placeholder: 'سيليكون رياضي' }
    ]
  },
  {
    id: 'accessories',
    name: 'الإكسسوارات',
    icon: <Usb className="w-5 h-5" />,
    defaultImage: "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    fields: [
      { key: 'accessory_type', label: 'نوع الإكسسوار', type: 'select', options: [
        { value: 'charger', label: 'شاحن' },
        { value: 'cable', label: 'كابل' },
        { value: 'case', label: 'حافظة' },
        { value: 'screen_protector', label: 'واقي شاشة' },
        { value: 'power_bank', label: 'بطارية محمولة' },
        { value: 'stand', label: 'حامل' },
        { value: 'adapter', label: 'محول' }
      ], required: true },
      { key: 'compatibility', label: 'التوافق', type: 'textarea', placeholder: 'متوافق مع iPhone، Samsung Galaxy، وغيرها' },
      { key: 'material', label: 'المادة', type: 'input', placeholder: 'بلاستيك مقوى، سيليكون' },
      { key: 'power_output', label: 'قوة الخرج (للشواحن)', type: 'input', placeholder: '20W، 65W', icon: <Battery className="w-4 h-4" /> },
      { key: 'cable_length', label: 'طول الكابل', type: 'input', placeholder: '1 متر، 2 متر' },
      { key: 'features', label: 'المميزات الخاصة', type: 'textarea', placeholder: 'شحن لاسلكي، مقاوم للصدمات، مضاد للبكتيريا' }
    ]
  }
];

interface ProductFormData {
  // الحقول الأساسية المشتركة
  name: string;
  brand: string;
  model: string;
  price: string;
  currency: string;
  description: string;
  category: string;
  color: string;
  warranty: string;
  availability: string;
  tags: string[];
  images: string[];
  // الحقول الديناميكية حسب الفئة
  specifications: Record<string, string>;
}

export default function CategoryBasedProductForm() {
  const [formData, setFormData] = useState<ProductFormData>({
    name: '',
    brand: '',
    model: '',
    price: '',
    currency: 'ريال',
    description: '',
    category: '',
    color: '',
    warranty: '',
    availability: '',
    tags: [],
    images: [],
    specifications: {}
  });

  const [newTag, setNewTag] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<ProductCategory | null>(null);

  // تحديث الفئة المختارة عند تغيير فئة المنتج
  useEffect(() => {
    if (formData.category) {
      const category = productCategories.find(cat => cat.id === formData.category);
      setSelectedCategory(category || null);
      // إعادة تعيين المواصفات عند تغيير الفئة
      setFormData(prev => ({ ...prev, specifications: {} }));
    }
  }, [formData.category]);

  const handleInputChange = (field: keyof ProductFormData, value: string) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handleSpecificationChange = (key: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      specifications: {
        ...prev.specifications,
        [key]: value
      }
    }));
  };

  const addTag = () => {
    if (newTag.trim() && !formData.tags.includes(newTag.trim())) {
      setFormData(prev => ({
        ...prev,
        tags: [...prev.tags, newTag.trim()]
      }));
      setNewTag('');
    }
  };

  const removeTag = (tagToRemove: string) => {
    setFormData(prev => ({
      ...prev,
      tags: prev.tags.filter(tag => tag !== tagToRemove)
    }));
  };

  const addImage = () => {
    const imageUrl = selectedCategory?.defaultImage || "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral";
    setFormData(prev => ({
      ...prev,
      images: [...prev.images, imageUrl]
    }));
  };

  const removeImage = (index: number) => {
    setFormData(prev => ({
      ...prev,
      images: prev.images.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Product Data:', formData);
  };

  const renderSpecificationField = (field: CategoryField) => {
    const value = formData.specifications[field.key] || '';

    if (field.type === 'select') {
      return (
        <div key={field.key} className="space-y-2">
          <Label className="flex items-center gap-2">
            {field.icon}
            {field.label}
            {field.required && <span className="text-destructive">*</span>}
          </Label>
          <Select onValueChange={(value) => handleSpecificationChange(field.key, value)}>
            <SelectTrigger>
              <SelectValue placeholder={`اختر ${field.label}`} />
            </SelectTrigger>
            <SelectContent>
              {field.options?.map(option => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      );
    }

    if (field.type === 'textarea') {
      return (
        <div key={field.key} className="space-y-2">
          <Label className="flex items-center gap-2">
            {field.icon}
            {field.label}
            {field.required && <span className="text-destructive">*</span>}
          </Label>
          <Textarea
            value={value}
            onChange={(e) => handleSpecificationChange(field.key, e.target.value)}
            placeholder={field.placeholder}
            className="min-h-[80px]"
          />
        </div>
      );
    }

    return (
      <div key={field.key} className="space-y-2">
        <Label className="flex items-center gap-2">
          {field.icon}
          {field.label}
          {field.required && <span className="text-destructive">*</span>}
        </Label>
        <Input
          value={value}
          onChange={(e) => handleSpecificationChange(field.key, e.target.value)}
          placeholder={field.placeholder}
          required={field.required}
        />
      </div>
    );
  };

  return (
    <div className="max-w-4xl mx-auto p-6 space-y-6" dir="rtl">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-3">
            <Package className="w-6 h-6" />
            إضافة منتج جديد
          </CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-8">
            {/* اختيار فئة المنتج */}
            <div className="space-y-6">
              <h3 className="flex items-center gap-2">
                <Tag className="w-5 h-5" />
                فئة المنتج
              </h3>
              
              <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                {productCategories.map((category) => (
                  <Card 
                    key={category.id}
                    className={`cursor-pointer transition-all hover:shadow-md ${
                      formData.category === category.id 
                        ? 'ring-2 ring-primary bg-primary/5' 
                        : 'hover:bg-accent/50'
                    }`}
                    onClick={() => handleInputChange('category', category.id)}
                  >
                    <CardContent className="p-4 flex flex-col items-center text-center space-y-2">
                      {category.icon}
                      <span className="text-sm">{category.name}</span>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {formData.category && (
              <>
                <Separator />

                {/* المعلومات الأساسية */}
                <div className="space-y-6">
                  <h3 className="flex items-center gap-2">
                    <Package className="w-5 h-5" />
                    المعلومات الأساسية
                  </h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="name">اسم المنتج <span className="text-destructive">*</span></Label>
                      <Input
                        id="name"
                        value={formData.name}
                        onChange={(e) => handleInputChange('name', e.target.value)}
                        placeholder={`أدخل اسم ${selectedCategory?.name}`}
                        required
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="brand">العلامة التجارية</Label>
                      <Input
                        id="brand"
                        value={formData.brand}
                        onChange={(e) => handleInputChange('brand', e.target.value)}
                        placeholder="Apple, Samsung, Sony..."
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="model">رقم الطراز</Label>
                      <Input
                        id="model"
                        value={formData.model}
                        onChange={(e) => handleInputChange('model', e.target.value)}
                        placeholder="A2848, XYZ-123..."
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="color">اللون</Label>
                      <Select onValueChange={(value) => handleInputChange('color', value)}>
                        <SelectTrigger>
                          <SelectValue placeholder="اختر اللون" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="black">أسود</SelectItem>
                          <SelectItem value="white">أبيض</SelectItem>
                          <SelectItem value="blue">أزرق</SelectItem>
                          <SelectItem value="gold">ذهبي</SelectItem>
                          <SelectItem value="silver">فضي</SelectItem>
                          <SelectItem value="red">أحمر</SelectItem>
                          <SelectItem value="green">أخضر</SelectItem>
                          <SelectItem value="purple">بنفسجي</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>

                <Separator />

                {/* السعر والتوفر */}
                <div className="space-y-6">
                  <h3 className="flex items-center gap-2">
                    <Tag className="w-5 h-5" />
                    السعر والتوفر
                  </h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="price">السعر <span className="text-destructive">*</span></Label>
                      <Input
                        id="price"
                        type="number"
                        value={formData.price}
                        onChange={(e) => handleInputChange('price', e.target.value)}
                        placeholder="0.00"
                        required
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="currency">العملة</Label>
                      <Select onValueChange={(value) => handleInputChange('currency', value)}>
                        <SelectTrigger>
                          <SelectValue placeholder="العملة" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="ريال">ريال سعودي</SelectItem>
                          <SelectItem value="درهم">درهم إماراتي</SelectItem>
                          <SelectItem value="دولار">دولار أمريكي</SelectItem>
                          <SelectItem value="يورو">يورو</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="availability">حالة التوفر</Label>
                      <Select onValueChange={(value) => handleInputChange('availability', value)}>
                        <SelectTrigger>
                          <SelectValue placeholder="حالة التوفر" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="available">متوفر</SelectItem>
                          <SelectItem value="limited">مخزون محدود</SelectItem>
                          <SelectItem value="preorder">طلب مسبق</SelectItem>
                          <SelectItem value="outofstock">نفد المخزون</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="warranty">فترة الضمان</Label>
                    <Select onValueChange={(value) => handleInputChange('warranty', value)}>
                      <SelectTrigger>
                        <SelectValue placeholder="اختر فترة الضمان" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="6months">6 أشهر</SelectItem>
                        <SelectItem value="1year">سنة واحدة</SelectItem>
                        <SelectItem value="2years">سنتان</SelectItem>
                        <SelectItem value="3years">ثلاث سنوات</SelectItem>
                        <SelectItem value="5years">خمس سنوات</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <Separator />

                {/* المواصفات التقنية حسب الفئة */}
                {selectedCategory && (
                  <div className="space-y-6">
                    <h3 className="flex items-center gap-2">
                      {selectedCategory.icon}
                      المواصفات التقنية - {selectedCategory.name}
                    </h3>
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                      {selectedCategory.fields.map(renderSpecificationField)}
                    </div>
                  </div>
                )}

                <Separator />

                {/* وصف المنتج */}
                <div className="space-y-4">
                  <Label htmlFor="description">وصف المنتج</Label>
                  <Textarea
                    id="description"
                    value={formData.description}
                    onChange={(e) => handleInputChange('description', e.target.value)}
                    placeholder="أدخل وصفاً مفصلاً عن المنتج وميزاته الرئيسية..."
                    className="min-h-[120px]"
                  />
                </div>

                <Separator />

                {/* العلامات */}
                <div className="space-y-4">
                  <Label>العلامات (Tags)</Label>
                  <div className="flex gap-2">
                    <Input
                      value={newTag}
                      onChange={(e) => setNewTag(e.target.value)}
                      placeholder="أضف علامة جديدة"
                      onKeyPress={(e) => e.key === 'Enter' && (e.preventDefault(), addTag())}
                    />
                    <Button type="button" onClick={addTag} variant="outline">
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>
                  {formData.tags.length > 0 && (
                    <div className="flex flex-wrap gap-2">
                      {formData.tags.map((tag, index) => (
                        <Badge key={index} variant="secondary" className="flex items-center gap-1">
                          {tag}
                          <X
                            className="w-3 h-3 cursor-pointer"
                            onClick={() => removeTag(tag)}
                          />
                        </Badge>
                      ))}
                    </div>
                  )}
                </div>

                <Separator />

                {/* صور المنتج */}
                <div className="space-y-4">
                  <Label>صور المنتج</Label>
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    {formData.images.map((image, index) => (
                      <div key={index} className="relative group">
                        <ImageWithFallback
                          src={image}
                          alt={`Product image ${index + 1}`}
                          className="w-full h-32 object-cover rounded-lg border"
                        />
                        <Button
                          type="button"
                          variant="destructive"
                          size="sm"
                          className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity"
                          onClick={() => removeImage(index)}
                        >
                          <X className="w-3 h-3" />
                        </Button>
                      </div>
                    ))}
                    <Button
                      type="button"
                      variant="outline"
                      className="h-32 border-dashed"
                      onClick={addImage}
                    >
                      <div className="flex flex-col items-center gap-2">
                        <Upload className="w-6 h-6" />
                        <span>رفع صورة جديدة</span>
                      </div>
                    </Button>
                  </div>
                </div>

                <Separator />

                {/* أزرار الحفظ */}
                <div className="flex justify-end gap-4">
                  <Button type="button" variant="outline">
                    إلغاء
                  </Button>
                  <Button type="submit">
                    حفظ المنتج
                  </Button>
                </div>
              </>
            )}
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
```

ملف التنسيقات - `/styles/globals.css`
```css
@custom-variant dark (&:is(.dark *));

:root {
  --font-size: 16px;
  --background: #ffffff;
  --foreground: oklch(0.145 0 0);
  --card: #ffffff;
  --card-foreground: oklch(0.145 0 0);
  --popover: oklch(1 0 0);
  --popover-foreground: oklch(0.145 0 0);
  --primary: #030213;
  --primary-foreground: oklch(1 0 0);
  --secondary: oklch(0.95 0.0058 264.53);
  --secondary-foreground: #030213;
  --muted: #ececf0;
  --muted-foreground: #717182;
  --accent: #e9ebef;
  --accent-foreground: #030213;
  --destructive: #d4183d;
  --destructive-foreground: #ffffff;
  --border: rgba(0, 0, 0, 0.1);
  --input: transparent;
  --input-background: #f3f3f5;
  --switch-background: #cbced4;
  --font-weight-medium: 500;
  --font-weight-normal: 400;
  --ring: oklch(0.708 0 0);
  --chart-1: oklch(0.646 0.222 41.116);
  --chart-2: oklch(0.6 0.118 184.704);
  --chart-3: oklch(0.398 0.07 227.392);
  --chart-4: oklch(0.828 0.189 84.429);
  --chart-5: oklch(0.769 0.188 70.08);
  --radius: 0.625rem;
  --sidebar: oklch(0.985 0 0);
  --sidebar-foreground: oklch(0.145 0 0);
  --sidebar-primary: #030213;
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.97 0 0);
  --sidebar-accent-foreground: oklch(0.205 0 0);
  --sidebar-border: oklch(0.922 0 0);
  --sidebar-ring: oklch(0.708 0 0);
}

.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --card: oklch(0.145 0 0);
  --card-foreground: oklch(0.985 0 0);
  --popover: oklch(0.145 0 0);
  --popover-foreground: oklch(0.985 0 0);
  --primary: oklch(0.985 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --secondary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --accent: oklch(0.269 0 0);
  --accent-foreground: oklch(0.985 0 0);
  --destructive: oklch(0.396 0.141 25.723);
  --destructive-foreground: oklch(0.637 0.237 25.331);
  --border: oklch(0.269 0 0);
  --input: oklch(0.269 0 0);
  --ring: oklch(0.439 0 0);
  --font-weight-medium: 500;
  --font-weight-normal: 400;
  --chart-1: oklch(0.488 0.243 264.376);
  --chart-2: oklch(0.696 0.17 162.48);
  --chart-3: oklch(0.769 0.188 70.08);
  --chart-4: oklch(0.627 0.265 303.9);
  --chart-5: oklch(0.645 0.246 16.439);
  --sidebar: oklch(0.205 0 0);
  --sidebar-foreground: oklch(0.985 0 0);
  --sidebar-primary: oklch(0.488 0.243 264.376);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.269 0 0);
  --sidebar-accent-foreground: oklch(0.985 0 0);
  --sidebar-border: oklch(0.269 0 0);
  --sidebar-ring: oklch(0.439 0 0);
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-card: var(--card);
  --color-card-foreground: var(--card-foreground);
  --color-popover: var(--popover);
  --color-popover-foreground: var(--popover-foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-secondary: var(--secondary);
  --color-secondary-foreground: var(--secondary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-accent: var(--accent);
  --color-accent-foreground: var(--accent-foreground);
  --color-destructive: var(--destructive);
  --color-destructive-foreground: var(--destructive-foreground);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-input-background: var(--input-background);
  --color-switch-background: var(--switch-background);
  --color-ring: var(--ring);
  --color-chart-1: var(--chart-1);
  --color-chart-2: var(--chart-2);
  --color-chart-3: var(--chart-3);
  --color-chart-4: var(--chart-4);
  --color-chart-5: var(--chart-5);
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);
  --color-sidebar: var(--sidebar);
  --color-sidebar-foreground: var(--sidebar-foreground);
  --color-sidebar-primary: var(--sidebar-primary);
  --color-sidebar-primary-foreground: var(--sidebar-primary-foreground);
  --color-sidebar-accent: var(--sidebar-accent);
  --color-sidebar-accent-foreground: var(--sidebar-accent-foreground);
  --color-sidebar-border: var(--sidebar-border);
  --color-sidebar-ring: var(--sidebar-ring);
}

@layer base {
{
    @apply border-border outline-ring/50;
  }

  body {
    @apply bg-background text-foreground;
  }
}

/**
Base typography. This is not applied to elements which have an ancestor with a Tailwind text class.
 */
@layer base {
  :where(:not(:has([class*=" text-"]), :not(:has([class^="text-"])))) {
    h1 {
      font-size: var(--text-2xl);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    h2 {
      font-size: var(--text-xl);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    h3 {
      font-size: var(--text-lg);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    h4 {
      font-size: var(--text-base);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    p {
      font-size: var(--text-base);
      font-weight: var(--font-weight-normal);
      line-height: 1.5;
    }

    label {
      font-size: var(--text-base);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    button {
      font-size: var(--text-base);
      font-weight: var(--font-weight-medium);
      line-height: 1.5;
    }

    input {
      font-size: var(--text-base);
      font-weight: var(--font-weight-normal);
      line-height: 1.5;
    }
  }
}

html {
  font-size: var(--font-size);
}
```

