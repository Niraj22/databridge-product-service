# db/seeds.rb for Product Service

# Clear existing data
puts "Clearing existing data..."
PriceHistory.delete_all
Inventory.delete_all
ProductCategory.delete_all
Product.delete_all
Category.delete_all

# Create Categories (with hierarchy)
puts "Creating categories..."

# Parent categories
electronics = Category.create!(name: 'Electronics', description: 'Electronic devices and gadgets', active: true)
clothing = Category.create!(name: 'Clothing', description: 'Apparel and accessories', active: true)
home = Category.create!(name: 'Home & Kitchen', description: 'Home goods and kitchen supplies', active: true)
books = Category.create!(name: 'Books', description: 'Books across various genres', active: true)
sports = Category.create!(name: 'Sports & Outdoors', description: 'Sports equipment and outdoor gear', active: true)

# Electronics subcategories
computers = Category.create!(name: 'Computers', description: 'Desktops, laptops, and accessories', parent: electronics, active: true)
phones = Category.create!(name: 'Smartphones', description: 'Mobile phones and accessories', parent: electronics, active: true)
audio = Category.create!(name: 'Audio', description: 'Headphones, speakers, and audio equipment', parent: electronics, active: true)
cameras = Category.create!(name: 'Cameras', description: 'Digital cameras and photography equipment', parent: electronics, active: true)

# Clothing subcategories
mens = Category.create!(name: 'Men\'s', description: 'Men\'s clothing and accessories', parent: clothing, active: true)
womens = Category.create!(name: 'Women\'s', description: 'Women\'s clothing and accessories', parent: clothing, active: true)
kids = Category.create!(name: 'Kids', description: 'Children\'s clothing and accessories', parent: clothing, active: true)

# Home subcategories
kitchen = Category.create!(name: 'Kitchen', description: 'Cookware, appliances, and kitchen tools', parent: home, active: true)
furniture = Category.create!(name: 'Furniture', description: 'Indoor and outdoor furniture', parent: home, active: true)
decor = Category.create!(name: 'Decor', description: 'Home decor and accessories', parent: home, active: true)

# Books subcategories
fiction = Category.create!(name: 'Fiction', description: 'Novels and fiction literature', parent: books, active: true)
nonfiction = Category.create!(name: 'Non-Fiction', description: 'Educational and informative books', parent: books, active: true)
technical = Category.create!(name: 'Technical', description: 'Technical and professional books', parent: books, active: true)

# Sports subcategories
fitness = Category.create!(name: 'Fitness', description: 'Fitness equipment and accessories', parent: sports, active: true)
outdoor = Category.create!(name: 'Outdoor Recreation', description: 'Camping, hiking, and outdoor activities', parent: sports, active: true)
team_sports = Category.create!(name: 'Team Sports', description: 'Equipment for team sports', parent: sports, active: true)

puts "Created #{Category.count} categories"

# Create Products
puts "Creating products..."

# Helper method to create product and related records
def create_product(name, description, sku, price, categories, inventory_qty, low_stock_threshold = 5, active = true)
  product = Product.create!(
    name: name,
    description: description,
    sku: sku,
    price: price,
    active: active
  )
  
  # Create product-category associations
  categories.each do |category|
    ProductCategory.create!(product: product, category: category)
  end
  
  # Update inventory
  inventory = product.inventory
  inventory.update!(quantity: inventory_qty, low_stock_threshold: low_stock_threshold)
  
  product
end

# Electronics - Computers
create_product(
  'MacBook Pro 16"', 
  'Apple MacBook Pro with M2 Pro chip, 16" Liquid Retina XDR display, 16GB RAM, 512GB SSD',
  'COMP-001',
  2499.99,
  [electronics, computers],
  20
)

create_product(
  'Dell XPS 13',
  'Dell XPS 13 with Intel Core i7, 13.4" FHD+ display, 16GB RAM, 512GB SSD',
  'COMP-002',
  1299.99,
  [electronics, computers],
  35
)

create_product(
  'HP Spectre x360',
  'HP Spectre x360 Convertible Laptop with Intel Core i7, 13.5" display, 16GB RAM, 1TB SSD',
  'COMP-003',
  1499.99,
  [electronics, computers],
  15
)

create_product(
  'Lenovo ThinkPad X1 Carbon',
  'Lenovo ThinkPad X1 Carbon Gen 10 with Intel Core i7, 14" display, 16GB RAM, 512GB SSD',
  'COMP-004',
  1799.99,
  [electronics, computers],
  10
)

create_product(
  'ASUS ROG Zephyrus G14',
  'ASUS ROG Zephyrus G14 Gaming Laptop with AMD Ryzen 9, RTX 3060, 14" QHD display, 16GB RAM, 1TB SSD',
  'COMP-005',
  1599.99,
  [electronics, computers],
  8
)

# Electronics - Smartphones
create_product(
  'iPhone 15 Pro',
  'Apple iPhone 15 Pro with A17 Pro chip, 6.1" Super Retina XDR display, 256GB storage',
  'PHONE-001',
  1099.99,
  [electronics, phones],
  50
)

create_product(
  'Samsung Galaxy S23 Ultra',
  'Samsung Galaxy S23 Ultra with Snapdragon 8 Gen 2, 6.8" Dynamic AMOLED display, 256GB storage',
  'PHONE-002',
  1199.99,
  [electronics, phones],
  45
)

create_product(
  'Google Pixel 8 Pro',
  'Google Pixel 8 Pro with Google Tensor G3, 6.7" LTPO OLED display, 128GB storage',
  'PHONE-003',
  999.99,
  [electronics, phones],
  30
)

create_product(
  'OnePlus 12',
  'OnePlus 12 with Snapdragon 8 Gen 3, 6.7" LTPO AMOLED display, 256GB storage',
  'PHONE-004',
  899.99,
  [electronics, phones],
  25
)

create_product(
  'Motorola Edge 40 Pro',
  'Motorola Edge 40 Pro with Snapdragon 8 Gen 2, 6.7" OLED display, 256GB storage',
  'PHONE-005',
  799.99,
  [electronics, phones],
  20
)

# Electronics - Audio
create_product(
  'Sony WH-1000XM5',
  'Sony WH-1000XM5 Wireless Noise-Canceling Headphones with 30-hour battery life',
  'AUDIO-001',
  399.99,
  [electronics, audio],
  40
)

create_product(
  'Apple AirPods Pro (2nd Gen)',
  'Apple AirPods Pro (2nd Generation) with Active Noise Cancellation and Transparency mode',
  'AUDIO-002',
  249.99,
  [electronics, audio],
  75
)

create_product(
  'Bose QuietComfort Earbuds II',
  'Bose QuietComfort Earbuds II with CustomTune technology and personalized noise cancellation',
  'AUDIO-003',
  299.99,
  [electronics, audio],
  30
)

create_product(
  'Sonos Era 300',
  'Sonos Era 300 Wireless Speaker with Spatial Audio and voice control',
  'AUDIO-004',
  449.99,
  [electronics, audio],
  15
)

create_product(
  'JBL Flip 6',
  'JBL Flip 6 Portable Bluetooth Speaker with IP67 waterproof rating',
  'AUDIO-005',
  129.99,
  [electronics, audio],
  60
)

# Electronics - Cameras
create_product(
  'Sony Alpha a7 IV',
  'Sony Alpha a7 IV Mirrorless Camera with 33MP full-frame sensor and 4K video',
  'CAM-001',
  2499.99,
  [electronics, cameras],
  12
)

create_product(
  'Canon EOS R6 Mark II',
  'Canon EOS R6 Mark II Mirrorless Camera with 24.2MP full-frame sensor and 4K60p video',
  'CAM-002',
  2499.99,
  [electronics, cameras],
  10
)

create_product(
  'Nikon Z8',
  'Nikon Z8 Mirrorless Camera with 45.7MP sensor and 8K video recording',
  'CAM-003',
  3999.99,
  [electronics, cameras],
  8
)

create_product(
  'Fujifilm X-T5',
  'Fujifilm X-T5 Mirrorless Camera with 40.2MP APS-C sensor and 6.2K video',
  'CAM-004',
  1699.99,
  [electronics, cameras],
  15
)

create_product(
  'GoPro HERO12 Black',
  'GoPro HERO12 Black Action Camera with 5.3K video and HyperSmooth 6.0 stabilization',
  'CAM-005',
  399.99,
  [electronics, cameras],
  40
)

# Clothing - Men's
create_product(
  'Classic Fit Oxford Shirt',
  'Men\'s Classic Fit Oxford Shirt made from premium cotton, available in multiple colors',
  'MENS-001',
  59.99,
  [clothing, mens],
  100
)

create_product(
  'Slim Fit Jeans',
  'Men\'s Slim Fit Jeans with stretch technology for comfort and mobility',
  'MENS-002',
  79.99,
  [clothing, mens],
  120
)

create_product(
  'Wool Blend Sweater',
  'Men\'s Wool Blend Sweater with ribbed collar and cuffs',
  'MENS-003',
  89.99,
  [clothing, mens],
  80
)

create_product(
  'Performance Polo Shirt',
  'Men\'s Performance Polo Shirt with moisture-wicking fabric',
  'MENS-004',
  49.99,
  [clothing, mens],
  150
)

create_product(
  'Tailored Fit Blazer',
  'Men\'s Tailored Fit Blazer in premium Italian wool',
  'MENS-005',
  249.99,
  [clothing, mens],
  30
)

# Clothing - Women's
create_product(
  'Silk Blouse',
  'Women\'s Silk Blouse with button front closure, available in multiple colors',
  'WOMENS-001',
  99.99,
  [clothing, womens],
  85
)

create_product(
  'High-Rise Skinny Jeans',
  'Women\'s High-Rise Skinny Jeans with stretch technology',
  'WOMENS-002',
  89.99,
  [clothing, womens],
  110
)

create_product(
  'Cashmere Sweater',
  'Women\'s Cashmere Sweater with crewneck design',
  'WOMENS-003',
  149.99,
  [clothing, womens],
  45
)

create_product(
  'Wrap Dress',
  'Women\'s Wrap Dress in floral print with adjustable tie',
  'WOMENS-004',
  129.99,
  [clothing, womens],
  60
)

create_product(
  'Tailored Blazer',
  'Women\'s Tailored Blazer with single-button closure',
  'WOMENS-005',
  199.99,
  [clothing, womens],
  40
)

# Clothing - Kids
create_product(
  'Kids Graphic T-Shirt',
  'Kids\' Graphic T-Shirt with fun designs, made from soft cotton',
  'KIDS-001',
  19.99,
  [clothing, kids],
  200
)

create_product(
  'Kids Cargo Pants',
  'Kids\' Cargo Pants with adjustable waist and multiple pockets',
  'KIDS-002',
  39.99,
  [clothing, kids],
  150
)

create_product(
  'Kids Hooded Sweatshirt',
  'Kids\' Hooded Sweatshirt with fleece lining and kangaroo pocket',
  'KIDS-003',
  29.99,
  [clothing, kids],
  125
)

create_product(
  'Kids Denim Jacket',
  'Kids\' Denim Jacket with button front closure',
  'KIDS-004',
  49.99,
  [clothing, kids],
  75
)

create_product(
  'Kids Pajama Set',
  'Kids\' Pajama Set with matching top and bottom',
  'KIDS-005',
  24.99,
  [clothing, kids],
  100
)

# Home & Kitchen - Kitchen
create_product(
  'Non-Stick Cookware Set',
  '10-Piece Non-Stick Cookware Set with heat-resistant handles',
  'KITCHEN-001',
  199.99,
  [home, kitchen],
  25
)

create_product(
  'Stand Mixer',
  'Professional Stand Mixer with 5-quart bowl and multiple attachments',
  'KITCHEN-002',
  349.99,
  [home, kitchen],
  20
)

create_product(
  'Chef\'s Knife',
  '8-Inch Chef\'s Knife made from high-carbon stainless steel',
  'KITCHEN-003',
  89.99,
  [home, kitchen],
  40
)

create_product(
  'Coffee Maker',
  'Programmable Coffee Maker with thermal carafe',
  'KITCHEN-004',
  129.99,
  [home, kitchen],
  35
)

create_product(
  'Air Fryer',
  'Digital Air Fryer with 5.8-quart capacity and multiple cooking presets',
  'KITCHEN-005',
  149.99,
  [home, kitchen],
  45
)

# Home & Kitchen - Furniture
create_product(
  'Sectional Sofa',
  'Modular Sectional Sofa with chaise lounge and storage',
  'FURN-001',
  1299.99,
  [home, furniture],
  5
)

create_product(
  'Queen Platform Bed',
  'Queen Size Platform Bed with upholstered headboard',
  'FURN-002',
  799.99,
  [home, furniture],
  8
)

create_product(
  'Dining Table Set',
  '7-Piece Dining Table Set with table and six chairs',
  'FURN-003',
  999.99,
  [home, furniture],
  6
)

create_product(
  'Office Desk',
  'Modern Office Desk with drawers and cable management',
  'FURN-004',
  349.99,
  [home, furniture],
  12
)

create_product(
  'Bookshelf',
  '5-Tier Bookshelf with open design',
  'FURN-005',
  199.99,
  [home, furniture],
  15
)

# Home & Kitchen - Decor
create_product(
  'Area Rug',
  '5\'x8\' Area Rug with geometric pattern',
  'DECOR-001',
  149.99,
  [home, decor],
  25
)

create_product(
  'Throw Pillows',
  'Set of 2 Decorative Throw Pillows with removable covers',
  'DECOR-002',
  39.99,
  [home, decor],
  50
)

create_product(
  'Table Lamp',
  'Modern Table Lamp with fabric shade',
  'DECOR-003',
  79.99,
  [home, decor],
  30
)

create_product(
  'Wall Art',
  'Framed Wall Art with abstract design',
  'DECOR-004',
  119.99,
  [home, decor],
  20
)

create_product(
  'Throw Blanket',
  'Soft Throw Blanket made from 100% cotton',
  'DECOR-005',
  49.99,
  [home, decor],
  40
)

# Books - Fiction
create_product(
  'The Last Horizon',
  'A captivating science fiction novel about space exploration and first contact',
  'BOOK-F001',
  24.99,
  [books, fiction],
  60
)

create_product(
  'Echoes of Silence',
  'A thrilling mystery novel set in a small coastal town',
  'BOOK-F002',
  19.99,
  [books, fiction],
  75
)

create_product(
  'The Forgotten Path',
  'An epic fantasy adventure with magic, dragons, and heroic quests',
  'BOOK-F003',
  22.99,
  [books, fiction],
  50
)

create_product(
  'Whispers in the Dark',
  'A psychological thriller that will keep you on the edge of your seat',
  'BOOK-F004',
  18.99,
  [books, fiction],
  65
)

create_product(
  'Love Beyond Time',
  'A romantic novel spanning across centuries with themes of destiny and fate',
  'BOOK-F005',
  16.99,
  [books, fiction],
  80
)

# Books - Non-Fiction
create_product(
  'The Art of Mindfulness',
  'A practical guide to mindfulness and meditation for everyday life',
  'BOOK-NF001',
  21.99,
  [books, nonfiction],
  70
)

create_product(
  'Journey Through History',
  'An exploration of world history from ancient civilizations to modern times',
  'BOOK-NF002',
  29.99,
  [books, nonfiction],
  45
)

create_product(
  'The Science of Everything',
  'An accessible overview of key scientific concepts and discoveries',
  'BOOK-NF003',
  26.99,
  [books, nonfiction],
  55
)

create_product(
  'Leaders Who Changed the World',
  'Biographies of influential leaders throughout history',
  'BOOK-NF004',
  24.99,
  [books, nonfiction],
  40
)

create_product(
  'Cook Like a Chef',
  'A comprehensive cookbook with recipes from professional chefs',
  'BOOK-NF005',
  32.99,
  [books, nonfiction, kitchen],
  50
)

# Books - Technical
create_product(
  'Ruby on Rails 7: The Complete Guide',
  'A comprehensive guide to developing web applications with Ruby on Rails 7',
  'BOOK-T001',
  49.99,
  [books, technical],
  25
)

create_product(
  'Machine Learning Fundamentals',
  'An introduction to machine learning concepts and algorithms',
  'BOOK-T002',
  54.99,
  [books, technical],
  30
)

create_product(
  'Data Structures and Algorithms',
  'A practical approach to data structures and algorithms with examples',
  'BOOK-T003',
  47.99,
  [books, technical],
  35
)

create_product(
  'Cloud Computing Architecture',
  'A guide to designing scalable and resilient cloud solutions',
  'BOOK-T004',
  59.99,
  [books, technical],
  20
)

create_product(
  'Cybersecurity Essentials',
  'Essential concepts and practices for securing digital systems',
  'BOOK-T005',
  42.99,
  [books, technical],
  30
)

# Sports & Outdoors - Fitness
create_product(
  'Adjustable Dumbbell Set',
  'Adjustable Dumbbell Set with weight range from 5 to 52.5 pounds',
  'FITNESS-001',
  299.99,
  [sports, fitness],
  15
)

create_product(
  'Yoga Mat',
  'Premium Yoga Mat with non-slip surface and carrying strap',
  'FITNESS-002',
  39.99,
  [sports, fitness],
  100
)

create_product(
  'Resistance Bands Set',
  'Set of 5 Resistance Bands with different resistance levels',
  'FITNESS-003',
  29.99,
  [sports, fitness],
  120
)

create_product(
  'Smart Fitness Watch',
  'Smart Fitness Watch with heart rate monitor and GPS',
  'FITNESS-004',
  199.99,
  [sports, fitness, electronics],
  40
)

create_product(
  'Adjustable Bench',
  'Adjustable Weight Bench for strength training',
  'FITNESS-005',
  169.99,
  [sports, fitness],
  20
)

# Sports & Outdoors - Outdoor Recreation
create_product(
  '2-Person Tent',
  'Lightweight 2-Person Tent for camping and backpacking',
  'OUTDOOR-001',
  199.99,
  [sports, outdoor],
  25
)

create_product(
  'Hiking Backpack',
  '55L Hiking Backpack with hydration system compatibility',
  'OUTDOOR-002',
  149.99,
  [sports, outdoor],
  30
)

create_product(
  'Sleeping Bag',
  'All-Season Sleeping Bag rated for 30°F',
  'OUTDOOR-003',
  89.99,
  [sports, outdoor],
  35
)

create_product(
  'Portable Camping Stove',
  'Compact Portable Camping Stove with piezo ignition',
  'OUTDOOR-004',
  69.99,
  [sports, outdoor],
  40
)

create_product(
  'Waterproof Binoculars',
  '10x42 Waterproof Binoculars for bird watching and outdoor activities',
  'OUTDOOR-005',
  129.99,
  [sports, outdoor],
  20
)

# Sports & Outdoors - Team Sports
create_product(
  'Basketball',
  'Official Size Basketball with grip technology',
  'TEAM-001',
  39.99,
  [sports, team_sports],
  50
)

create_product(
  'Soccer Ball',
  'Size 5 Soccer Ball for matches and training',
  'TEAM-002',
  34.99,
  [sports, team_sports],
  60
)

create_product(
  'Baseball Glove',
  '12-Inch Baseball Glove for outfield positions',
  'TEAM-003',
  79.99,
  [sports, team_sports],
  25
)

create_product(
  'Volleyball',
  'Indoor/Outdoor Volleyball with soft touch cover',
  'TEAM-004',
  29.99,
  [sports, team_sports],
  40
)

create_product(
  'Tennis Racket',
  'Performance Tennis Racket with vibration dampening technology',
  'TEAM-005',
  129.99,
  [sports, team_sports],
  20
)

# Create some inactive products for testing
create_product(
  'Discontinued Laptop',
  'Older model laptop no longer in production',
  'DISC-001',
  899.99,
  [electronics, computers],
  5,
  5,
  false
)

create_product(
  'Last Season Jacket',
  'Last season\'s jacket style that\'s no longer carried',
  'DISC-002',
  129.99,
  [clothing, mens],
  8,
  5,
  false
)

# Create some low-stock products
create_product(
  'Limited Edition Watch',
  'Limited edition smartwatch with special features',
  'LTD-001',
  499.99,
  [electronics],
  3,
  5
)

create_product(
  'Collectible Action Figure',
  'Rare collectible action figure from popular franchise',
  'LTD-002',
  59.99,
  [home, decor],
  2,
  5
)

puts "Created #{Product.count} products"
puts "Created #{ProductCategory.count} product-category associations"
puts "Updated #{Inventory.count} inventory records"
puts "Created #{PriceHistory.count} price history records"

puts "Seed data creation complete!"