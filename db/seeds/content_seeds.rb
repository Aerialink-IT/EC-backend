# Seed file for Content Management System
# This populates the Content model with default values from locale files

puts "Seeding Content Management System..."

# Helper method to create or update content
def create_content(key, section, description, content_en, content_ja)
  content = Content.find_or_initialize_by(key: key)
  content.assign_attributes(
    section: section,
    description: description,
    content_en: content_en,
    content_ja: content_ja
  )
  if content.save
    puts "  ✓ Created/Updated: #{key}"
  else
    puts "  ✗ Error creating #{key}: #{content.errors.full_messages.join(', ')}"
  end
end

# Footer Section
puts "\nCreating Footer content..."
create_content(
  'footer.title',
  'footer',
  'Main footer title/description text',
  'Our flooring products fit your lifestyle and deliver quality you can be proud of — from home to commercial spaces.',
  '当社のフローリング製品は、ご家庭から商業施設まで、お客様のライフスタイルにフィットし、誇れる品質をお届けします。'
)

create_content(
  'footer.terms',
  'footer',
  'Terms of service link text',
  'Terms of service',
  '特定商取引法に基づく表示'
)

create_content(
  'footer.privacy_policy',
  'footer',
  'Privacy policy link text',
  'privacy policy',
  'プライバシー規定'
)

create_content(
  'footer.faq',
  'footer',
  'FAQ link text',
  'FAQs',
  'よくある質問'
)

create_content(
  'footer.all_rights',
  'footer',
  'Copyright text',
  'All Rights Reserved',
  '全著作権所有'
)

create_content(
  'footer.newsletter.title',
  'footer',
  'Newsletter subscription title',
  'RECEIVE NOTIFICATIONS',
  '通知を受け取る'
)

create_content(
  'footer.newsletter.enter_email',
  'footer',
  'Newsletter email input placeholder',
  'Enter your email address',
  'メールアドレスを入力してください'
)

create_content(
  'footer.newsletter.subscribe',
  'footer',
  'Newsletter subscribe button text',
  'Subscribe to Newsletter',
  'メルマガに登録する'
)

# Header/Navbar Section
puts "\nCreating Header/Navbar content..."
create_content(
  'header.home',
  'header',
  'Home navigation link',
  'Home',
  'ホーム'
)

create_content(
  'header.community_forum',
  'header',
  'Community Forum navigation link',
  'Community Forum',
  'メンバーコミュニティ'
)

create_content(
  'header.virtual_showroom',
  'header',
  'Virtual Showroom navigation link',
  'Virtual Showroom',
  'ヴァーチャルショールーム'
)

create_content(
  'header.about_us',
  'header',
  'About Us navigation link',
  'About Us',
  '会社概要'
)

create_content(
  'header.search_placeholder',
  'header',
  'Search input placeholder',
  'Search products...',
  '製品を検索...'
)

create_content(
  'header.username',
  'header',
  'Username label',
  'Username',
  'ユーザー名'
)

create_content(
  'header.profile',
  'header',
  'Profile link',
  'Profile',
  'プロフィール'
)

create_content(
  'header.logout',
  'header',
  'Logout link',
  'Logout',
  'ログアウト'
)

create_content(
  'header.orders',
  'header',
  'Orders link',
  'Orders',
  '注文'
)

# Home Section
puts "\nCreating Home page content..."
create_content(
  'home.add_to_cart',
  'home',
  'Add to cart button text',
  'Add To Cart',
  'カートに追加'
)

create_content(
  'home.go_to_cart',
  'home',
  'Go to cart button text',
  'Go to Cart',
  'カートへ進む'
)

create_content(
  'home.out_of_stock',
  'home',
  'Out of stock message',
  'Out of Stock',
  '在庫切れ'
)

create_content(
  'home.loading',
  'home',
  'Loading text',
  'Loading...',
  '読み込み中...'
)

create_content(
  'home.load_more',
  'home',
  'Load more products button',
  'Load More',
  '更に読み込む'
)

create_content(
  'home.interested_in',
  'home',
  'Recommended products section title',
  'You may be also interested in',
  'あなたへのオススメ'
)

create_content(
  'home.best_selling',
  'home',
  'Best selling products title',
  'Best Selling Products',
  'ベストセラー商品'
)

create_content(
  'home.our_product',
  'home',
  'Our product section title',
  'Our Product',
  '商品について'
)

create_content(
  'home.filters',
  'home',
  'Filters label',
  'Filters',
  'フィルター'
)

create_content(
  'home.sort_by',
  'home',
  'Sort by label',
  'Sort By',
  'サイズで選ぶ'
)

create_content(
  'home.live_chat',
  'home',
  'Live chat label',
  'Live chat',
  'ライブチャット'
)

create_content(
  'home.contact_us',
  'home',
  'Contact us label',
  'Contact Us',
  'お問い合わせ'
)

create_content(
  'home.faq',
  'home',
  'FAQ label',
  'FAQs',
  'よくある質問'
)

create_content(
  'home.office_timing',
  'home',
  'Office timing label',
  'Office Timing',
  '営業時間'
)

create_content(
  'home.open_time',
  'home',
  'Open time text',
  'Mon-Fri (10am - 5pm)',
  '月～金（午前10時～午後5時）'
)

create_content(
  'home.holiday',
  'home',
  'Holiday text',
  'Sat, Sun, Holiday',
  '土、日、祝日'
)

create_content(
  'home.instructions',
  'home',
  'Instructions label',
  'Instructions',
  '説明書'
)

create_content(
  'home.samples',
  'home',
  'Samples label',
  'Samples',
  'サンプル'
)

create_content(
  'home.safe_payment',
  'home',
  'Safe payment feature',
  'Safe Payment',
  'お支払方法について'
)

create_content(
  'home.nationwide_delivery',
  'home',
  'Nationwide delivery feature',
  'Nationwide delivery',
  '配送方法について'
)

create_content(
  'home.fast_returns',
  'home',
  'Fast returns feature',
  'Fast and easy returns',
  '返品・交換について'
)

create_content(
  'home.best_quality',
  'home',
  'Best quality feature',
  'Best Quality',
  '品質について'
)

create_content(
  'home.show_less',
  'home',
  'Show less button text',
  'Show Less',
  '表示を減らす'
)

create_content(
  'home.all',
  'home',
  'All categories filter',
  'All',
  'すべて'
)

create_content(
  'home.err_fetching_products',
  'home',
  'Error message when fetching products fails',
  'error fetching products:',
  '商品の取得中にエラーが発生しました:'
)

# About Us Section
puts "\nCreating About Us content..."
create_content(
  'about_us.welcome',
  'about_us',
  'About Us welcome title',
  'Welcome To Our Community',
  '私たちについてor 会社概要'
)

create_content(
  'about_us.our_product',
  'about_us',
  'Our product section title',
  'Our Product',
  '商品についてor 品質へのこだわり'
)

create_content(
  'about_us.contact_information',
  'about_us',
  'Contact information section title',
  'Contact Information',
  'アクセス'
)

create_content(
  'about_us.contact_us',
  'about_us',
  'Contact us label',
  'Contact Us',
  'お問い合わせ'
)

create_content(
  'about_us.inquiry_form',
  'about_us',
  'Inquiry form title',
  'Inquiry Form',
  'お問い合わせフォーム'
)

create_content(
  'about_us.read_more',
  'about_us',
  'Read more button text',
  'Read More',
  '更に詳しく'
)

create_content(
  'about_us.send_inquiry',
  'about_us',
  'Send inquiry button text',
  'Send Inquiry',
  'お問い合わせを送信'
)

# About Us - Main content fields
create_content(
  'about_us.title',
  'about_us',
  'Main banner title on About Us page',
  'Welcome To Our Community',
  '私たちのコミュニティへようこそ'
)

create_content(
  'about_us.community_time',
  'about_us',
  'Community time text on banner',
  'Mon-Fri (10am - 5pm)',
  '月〜金（10時〜17時）'
)

create_content(
  'about_us.description',
  'about_us',
  'Main description text in Our Product section',
  'Our flooring products fit your lifestyle and deliver quality you can be proud of — from home to commercial spaces.',
  '当社のフローリング製品は、ご家庭から商業施設まで、お客様のライフスタイルにフィットし、誇れる品質をお届けします。'
)

create_content(
  'about_us.product_description',
  'about_us',
  'Product description text in Our Product section',
  'Praesent tincidunt euismod ante. Vivamus placerat at enim non condimentum. Donec sit amet mauris purus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  'プレゼントティンキドゥントエウイスモッドアンテ。ビバムスプラセラットアットエニムノンコンディメントゥム。ドネクシットアメットマウリスプルス。ロレムイプサムドロールシットアメット、コンセクテトゥールアディピシングエリット。'
)

create_content(
  'about_us.email',
  'about_us',
  'Contact email address',
  'info@example.com',
  'info@example.com'
)

create_content(
  'about_us.phone',
  'about_us',
  'Contact phone number',
  '+81-3-1234-5678',
  '+81-3-1234-5678'
)

create_content(
  'about_us.address',
  'about_us',
  'Business address',
  '123 Main Street, Tokyo, Japan 100-0001',
  '〒100-0001 東京都千代田区千代田1-1-1'
)

create_content(
  'about_us.contact_us_time',
  'about_us',
  'Contact us business hours',
  'Mon-Fri (10am - 5pm)',
  '月〜金（10時〜17時）'
)

# About Us - Image fields (will be uploaded via dashboard)
create_content(
  'about_us.banner_image',
  'about_us',
  'Banner image for About Us page header',
  '',
  ''
)

create_content(
  'about_us.product_image',
  'about_us',
  'Product image in Our Product section',
  '',
  ''
)

create_content(
  'about_us.map_image',
  'about_us',
  'Map image in Contact Information section',
  '',
  ''
)

# Gallery images (1-9)
(1..9).each do |i|
  create_content(
    "about_us.gallery_image_#{i}",
    'about_us',
    "Gallery image #{i} for About Us photo grid",
    '',
    ''
  )
end

# Community Forum Section
puts "\nCreating Community Forum page content..."
create_content(
  'community.welcome',
  'community_forum',
  'Welcome message for community forum',
  'Welcome to our community',
  'コミュニティへようこそ'
)

create_content(
  'community.select_product',
  'community_forum',
  'Select product label',
  'Select a product',
  '商品を選ぶ'
)

create_content(
  'community.description',
  'community_forum',
  'Description label',
  'Description',
  '商品詳細'
)

create_content(
  'community.full_name_label',
  'community_forum',
  'Full name label',
  'Full Name',
  '氏名'
)

create_content(
  'community.email_address_label',
  'community_forum',
  'Email address label',
  'Email Address',
  'Eメールアドレス'
)

create_content(
  'community.question_example',
  'community_forum',
  'Question example placeholder',
  'Eg: How do I clean wood?',
  '例: 木材をどのように掃除すればよいですか？'
)

create_content(
  'community.write_question_comment',
  'community_forum',
  'Write question/comment placeholder',
  'Write your question or comment here',
  'ここに質問またはコメントを入力してください'
)

create_content(
  'community.read_more',
  'community_forum',
  'Read more about product',
  'Read More About This Product',
  'この商品について更に詳しく'
)

create_content(
  'community.questions_answers',
  'community_forum',
  'Questions and answers section title',
  'Questions & Answers',
  '質問と回答'
)

create_content(
  'community.reviews',
  'community_forum',
  'Reviews section title',
  'Reviews',
  'レビューを投稿する'
)

create_content(
  'community.ask_question',
  'community_forum',
  'Ask a community button',
  'Ask a community',
  'コミュニティに聞く'
)

create_content(
  'community.full_name',
  'community_forum',
  'Full name field',
  'Full Name',
  '氏名'
)

create_content(
  'community.email_address',
  'community_forum',
  'Email address field',
  'Email address',
  'eメールアドレス'
)

create_content(
  'community.title',
  'community_forum',
  'Title field',
  'Title',
  '質問のタイトル'
)

create_content(
  'community.comments',
  'community_forum',
  'Comments field',
  'Comments',
  '質問内容'
)

create_content(
  'community.post_comment',
  'community_forum',
  'Post comment button',
  'Post Comment',
  '質問投稿'
)

create_content(
  'community.search',
  'community_forum',
  'Search placeholder',
  'Search',
  '検索'
)

create_content(
  'community.failed_to_load_products',
  'community_forum',
  'Failed to load products error',
  'Failed to load products. Please try again later.',
  '商品の読み込みに失敗しました。しばらくしてからもう一度お試しください。'
)

# Virtual Showroom Section
puts "\nCreating Virtual Showroom page content..."
create_content(
  'virtual.virtual_tour',
  'virtual_showroom',
  'Virtual tour title',
  '360° virtual tour',
  '360°バーチャルツアー'
)

create_content(
  'virtual.select_product',
  'virtual_showroom',
  'Select product label',
  'Select a Product',
  '商品を選ぶ'
)

create_content(
  'virtual.change',
  'virtual_showroom',
  'Change button',
  'Change',
  '変更'
)

create_content(
  'virtual.select',
  'virtual_showroom',
  'Select button',
  'Select',
  '選択'
)

create_content(
  'virtual.upload_photo',
  'virtual_showroom',
  'Upload photo label',
  'Upload photo',
  '写真をアップロード'
)

create_content(
  'virtual.left_side_wall',
  'virtual_showroom',
  'Left side wall label',
  'left side wall',
  '左側'
)

create_content(
  'virtual.right_side_wall',
  'virtual_showroom',
  'Right side wall label',
  'right side wall',
  '右側'
)

create_content(
  'virtual.back_side_wall',
  'virtual_showroom',
  'Back side wall label',
  'back side wall',
  '奥側'
)

create_content(
  'virtual.center_side_wall',
  'virtual_showroom',
  'Center side wall label',
  'center side wall',
  '中央側の壁'
)

create_content(
  'virtual.a_product',
  'virtual_showroom',
  'A product label',
  'a Product',
  '商品'
)

create_content(
  'virtual.360_virtual_tour',
  'virtual_showroom',
  '360 virtual tour title',
  '360° virtual tour',
  '360°バーチャルツア'
)

create_content(
  'virtual.virtual_tour_description',
  'virtual_showroom',
  'Virtual tour description',
  'Having hard time to decide which design to choose? No problem. Try our virtual showroom to see which one fits your room the best. Add at least one product to your shopping cart, then upload photos of your room wall, left, back and right side. Your room with the carpet will be displayed.',
  '色や柄で迷っているなら、バーチャルルームで実際のお部屋に合うか試しましょう。カートに商品を１つ以上追加し、「選択商品」から選び、下にご自身のお部屋の３面の写真をアップロードすると、合成した画像が表示されます。ぜひお試しください。'
)

# Auth/Login/Register Section
puts "\nCreating Auth/Login/Register page content..."
create_content(
  'auth.login.login',
  'auth',
  'Login button text',
  'Login',
  'ログイン'
)

create_content(
  'auth.login.title',
  'auth',
  'Login page title',
  'Login to access your account',
  'アカウントにアクセスするにはログインしてください'
)

create_content(
  'auth.login.email',
  'auth',
  'Email field label',
  'Email',
  'メール'
)

create_content(
  'auth.login.password',
  'auth',
  'Password field label',
  'Password',
  'パスワード'
)

create_content(
  'auth.login.remember_me',
  'auth',
  'Remember me checkbox',
  'Remember me',
  'ログイン情報を記憶する'
)

create_content(
  'auth.login.forgot_password',
  'auth',
  'Forgot password link',
  'Forgot Password?',
  'パスワードをお忘れですか？'
)

create_content(
  'auth.login.no_account',
  'auth',
  'No account text',
  "Don't have an account? ",
  'アカウントをお持ちではありませんか？'
)

create_content(
  'auth.login.register',
  'auth',
  'Register link',
  'Register',
  '登録'
)

create_content(
  'auth.signup.first_name',
  'auth',
  'First name field',
  'First Name',
  '名'
)

create_content(
  'auth.signup.last_name',
  'auth',
  'Last name field',
  'Last Name',
  '姓'
)

create_content(
  'auth.signup.email',
  'auth',
  'Email field',
  'Email',
  'メール'
)

create_content(
  'auth.signup.phone',
  'auth',
  'Phone number field',
  'Phone Number',
  '電話番号'
)

create_content(
  'auth.signup.password',
  'auth',
  'Password field',
  'Password',
  'パスワード'
)

create_content(
  'auth.signup.confirm_password',
  'auth',
  'Confirm password field',
  'Confirm Password',
  'パスワード確認'
)

create_content(
  'auth.signup.agree_terms',
  'auth',
  'Agree to terms checkbox',
  'I agree to all the Terms and Privacy Policies',
  '利用規約とプライバシーポリシーに同意します'
)

create_content(
  'auth.signup.create_account',
  'auth',
  'Create account button',
  'Create Account',
  'アカウント作成'
)

create_content(
  'auth.signup.already_have_account',
  'auth',
  'Already have account text',
  'Already have an account?',
  'すでにアカウントをお持ちですか？'
)

create_content(
  'auth.forgot_password.title',
  'auth',
  'Forgot password title',
  'Forgot your password?',
  'パスワードをお忘れですか？'
)

create_content(
  'auth.forgot_password.description',
  'auth',
  'Forgot password description',
  "Don't worry, happens to all of us. Enter your email below to recover your password.",
  '心配しないでください。誰にでも起こることです。パスワードを回復するために、以下にメールアドレスを入力してください。'
)

create_content(
  'auth.forgot_password.submit',
  'auth',
  'Submit button',
  'Submit',
  '送信'
)

create_content(
  'auth.forgot_password.back_to_login',
  'auth',
  'Back to login link',
  'Back to login',
  'ログインに戻る'
)

# Cart Section
puts "\nCreating Cart page content..."
create_content(
  'cart.cart',
  'cart',
  'Cart page title',
  'Cart',
  'カート'
)

create_content(
  'cart.checkout',
  'cart',
  'Checkout button',
  'Checkout',
  'チェックアウト'
)

create_content(
  'cart.cart_total',
  'cart',
  'Cart total label',
  'Cart Total',
  'カート合計'
)

create_content(
  'cart.shipping',
  'cart',
  'Shipping label',
  'Shipping',
  '配送'
)

create_content(
  'cart.total',
  'cart',
  'Total label',
  'Total',
  '合計'
)

create_content(
  'cart.proceed_to_checkout',
  'cart',
  'Proceed to checkout button',
  'Proceed to Checkout',
  'チェックアウトに進む'
)

create_content(
  'cart.product',
  'cart',
  'Product label',
  'Product',
  '商品'
)

create_content(
  'cart.price',
  'cart',
  'Price label',
  'Price',
  '価格'
)

create_content(
  'cart.quantity',
  'cart',
  'Quantity label',
  'Quantity',
  '数量'
)

create_content(
  'cart.size',
  'cart',
  'Size label',
  'Size',
  'サイズ'
)

create_content(
  'cart.subtotal',
  'cart',
  'Subtotal label',
  'Subtotal',
  '小計'
)

create_content(
  'cart.continue_shopping',
  'cart',
  'Continue shopping button',
  'Continue Shopping',
  'ショッピングを続ける'
)

create_content(
  'cart.remove_item',
  'cart',
  'Remove item button',
  'Remove Item',
  'アイテムを削除'
)

create_content(
  'cart.no_data_message',
  'cart',
  'Empty cart message',
  'There is no data. Please add something to your cart.',
  'データがありません。カートに何かを追加してください。'
)

# Profile Section
puts "\nCreating Profile page content..."
create_content(
  'profile.account',
  'profile',
  'Account label',
  'Account',
  'アカウント'
)

create_content(
  'profile.hello',
  'profile',
  'Hello greeting',
  'Hello',
  'こんにちは'
)

create_content(
  'profile.profile',
  'profile',
  'Profile label',
  'Profile',
  'プロフィール'
)

create_content(
  'profile.order_history',
  'profile',
  'Order history label',
  'Order History',
  '注文履歴'
)

create_content(
  'profile.delivery_address',
  'profile',
  'Delivery address label',
  'Delivery Address',
  '配送先住所'
)

create_content(
  'profile.username',
  'profile',
  'Username label',
  'Username',
  'ユーザー名'
)

create_content(
  'profile.enter_username',
  'profile',
  'Enter username placeholder',
  'Enter username',
  'ユーザー名を入力'
)

create_content(
  'profile.login_and_security',
  'profile',
  'Login and security label',
  'Login & Security',
  'ログインとセキュリティ'
)

create_content(
  'profile.messages',
  'profile',
  'Messages label',
  'Messages',
  'メッセージ'
)

create_content(
  'profile.contact_us',
  'profile',
  'Contact us label',
  'Contact Us',
  'お問い合わせ'
)

create_content(
  'profile.faqs',
  'profile',
  'FAQs label',
  'FAQs',
  'よくある質問'
)

create_content(
  'profile.submit_enquiry',
  'profile',
  'Submit enquiry button',
  'Submit Inquiry',
  'お問い合わせを送信'
)

create_content(
  'profile.profile_description',
  'profile',
  'Description text for Profile card',
  'Manage your account settings, update personal information, and view your profile details.',
  'アカウント設定の管理、個人情報の更新、プロフィール詳細の確認ができます。'
)

create_content(
  'profile.order_history_description',
  'profile',
  'Description text for Order History card',
  'View your past orders, track order status, and manage your purchase history.',
  '過去の注文を確認し、注文状況を追跡し、購入履歴を管理できます。'
)

create_content(
  'profile.delivery_address_description',
  'profile',
  'Description text for Delivery Address card',
  'Manage your delivery addresses, add new locations, and set default shipping address.',
  '配送先住所の管理、新しい住所の追加、デフォルトの配送先住所の設定ができます。'
)

create_content(
  'profile.messages_description',
  'profile',
  'Description text for Messages card',
  'View and manage your messages, inquiries, and communications with customer support.',
  'メッセージ、お問い合わせ、カスタマーサポートとの連絡を確認・管理できます。'
)

create_content(
  'profile.contact_us_description',
  'profile',
  'Description text for Contact Us card',
  'Get in touch with our customer support team for assistance and inquiries.',
  'サポートチームにお問い合わせいただき、ご質問やご相談ができます。'
)

create_content(
  'profile.faqs_description',
  'profile',
  'Description text for FAQs card',
  'Find answers to frequently asked questions and get help with common issues.',
  'よくある質問の回答を確認し、一般的な問題の解決方法を見つけることができます。'
)

create_content(
  'profile.submit_enquiry_description',
  'profile',
  'Description text for Submit Inquiry card',
  'Submit your inquiries, feedback, or requests directly to our support team.',
  'お問い合わせ、フィードバック、またはリクエストをサポートチームに直接送信できます。'
)

# Points Management Section
puts "\nCreating Points Management page content..."
create_content(
  'points.points_management',
  'points_management',
  'Points management title',
  'Points Management',
  'ポイント管理'
)

create_content(
  'points.points_balance',
  'points_management',
  'Points balance label',
  'Points Balance',
  'ポイント残高'
)

create_content(
  'points.total_save',
  'points_management',
  'Total save label',
  'Total Save',
  '合計節約'
)

create_content(
  'points.redeem_points',
  'points_management',
  'Redeem points button',
  'Redeem Points',
  'ポイントを交換'
)

create_content(
  'points.points_history',
  'points_management',
  'Points history label',
  'Points History',
  'ポイント履歴'
)

create_content(
  'points.how_to_earn_points',
  'points_management',
  'How to earn points label',
  'How to Earn Points',
  'ポイントの獲得方法'
)

create_content(
  'points.total_points',
  'points_management',
  'Total points label',
  'Total Points',
  '合計ポイント'
)

create_content(
  'points.you_need',
  'points_management',
  'You need text',
  'You need',
  'あと'
)

create_content(
  'points.points_to_reach',
  'points_management',
  'Points to reach text',
  'points to reach',
  'ポイントで到達'
)

create_content(
  'points.valid_until',
  'points_management',
  'Valid until label',
  'Valid until',
  '有効期限'
)

create_content(
  'points.discount',
  'points_management',
  'Discount label',
  'Discount',
  '割引'
)

# Wishlist Section
puts "\nCreating Wishlist page content..."
create_content(
  'wishlist.wishlist',
  'wishlist',
  'Wishlist page title',
  'WishList',
  'ウィッシュリスト'
)

create_content(
  'wishlist.go_back_to_homepage',
  'wishlist',
  'Go back to homepage button',
  'Go Back To Homepage',
  'ホームページに戻る'
)

create_content(
  'wishlist.please_add_something',
  'wishlist',
  'Empty wishlist message',
  'Please add something to your WishList.',
  'ウィッシュリストに何かを追加してください。'
)

# FAQ Section
puts "\nCreating FAQ page content..."
create_content(
  'faq.title',
  'faq',
  'FAQ page title',
  'Frequently Asked Questions',
  'よくある質問'
)

create_content(
  'faq.load_more',
  'faq',
  'Load more questions button',
  'Load More Questions',
  '質問をもっと見る'
)

create_content(
  'faq.show_less',
  'faq',
  'Show less button',
  'Show Less',
  '表示を減らす'
)

# Instructions Section
puts "\nCreating Instructions page content..."
create_content(
  'instructions.title',
  'instructions',
  'Instructions page title',
  'Installation & Samples Guide',
  '設置とサンプルガイド'
)

create_content(
  'instructions.installation_title',
  'instructions',
  'Installation title',
  'Wood Carpet Installation Guide',
  'ウッドカーペット設置ガイド'
)

create_content(
  'instructions.samples_title',
  'instructions',
  'Samples title',
  'Free Samples',
  '無料サンプル'
)

create_content(
  'instructions.virtual_showroom',
  'instructions',
  'Virtual showroom text',
  'Our online 360º Virtual Showroom allows you to visualize how your selected carpet will look in your room—try it now!',
  'オンライン360ºバーチャルショールームで、選択したカーペットがお部屋にどのように見えるかを視覚化できます。今すぐお試しください！'
)

create_content(
  'instructions.request_samples',
  'instructions',
  'Request samples button',
  'Request Free Samples',
  '無料サンプルをリクエスト'
)

# Shipping Section
puts "\nCreating Shipping page content..."
create_content(
  'shipping.title',
  'shipping',
  'Shipping information title',
  'Shipping Information',
  '配送情報'
)

create_content(
  'shipping.delivery_title',
  'shipping',
  'Delivery information title',
  'Delivery Information',
  '配送情報'
)

create_content(
  'shipping.free_shipping',
  'shipping',
  'Free shipping text',
  'Free shipping except for Hokkaido, Okinawa, and other remote islands.',
  '北海道、沖縄、その他の離島を除き、送料無料。'
)

create_content(
  'shipping.fees_title',
  'shipping',
  'Shipping fees title',
  'Shipping Fees',
  '送料'
)

create_content(
  'shipping.delivery_schedule',
  'shipping',
  'Delivery schedule title',
  'Delivery Schedule',
  '配送スケジュール'
)

create_content(
  'shipping.returns_title',
  'shipping',
  'Returns and exchanges title',
  'Returns and Exchanges',
  '返品と交換'
)

# Product Details Section
puts "\nCreating Product Details page content..."
create_content(
  'product_detail.add_to_cart',
  'product_detail',
  'Add to cart button',
  'Add To Cart',
  'カートに追加'
)

create_content(
  'product_detail.go_to_cart',
  'product_detail',
  'Go to cart button',
  'Go to Cart',
  'カートへ進む'
)

create_content(
  'product_detail.out_of_stock',
  'product_detail',
  'Out of stock message',
  'Out of Stock',
  '在庫切れ'
)

create_content(
  'product_detail.interested_in',
  'product_detail',
  'Interested in section title',
  'You may be also interested in',
  'あなたへのオススメ'
)

create_content(
  'product_detail.visit_360_virtual',
  'product_detail',
  'Visit 360 virtual showroom text',
  'Visit the 360° virtual showroomto see how it fit to your room. It\'s fun!',
  '360°バーチャルショールームを訪れて、お部屋にどのようにフィットするか確認してください。楽しいですよ！'
)

create_content(
  'product_detail.description',
  'product_detail',
  'Description label',
  'Description',
  '商品説明'
)

create_content(
  'product_detail.additional_information',
  'product_detail',
  'Additional information label',
  'Additional information',
  '追加情報'
)

create_content(
  'product_detail.reviews',
  'product_detail',
  'Reviews label',
  'Reviews',
  'レビュー'
)

create_content(
  'product_detail.free_delivery',
  'product_detail',
  'Free delivery text',
  'Free Shipping',
  '送料無料'
)

# Home Page Images Section
puts "\nCreating Home page images..."
create_content(
  'home.banner_image',
  'home',
  'Top banner image URL on home page',
  '',
  ''
)

create_content(
  'home.second_banner_image',
  'home',
  'Second banner image URL in the gray box section on home page',
  '',
  ''
)

# Sidebar Section
puts "\nCreating Sidebar content..."
create_content(
  'sidebar.live_chat',
  'sidebar',
  'Live chat link in sidebar',
  'Live chat',
  'ライブチャット'
)

create_content(
  'sidebar.contact_us',
  'sidebar',
  'Contact Us link in sidebar',
  'Contact Us',
  'お問い合わせ'
)

create_content(
  'sidebar.faq',
  'sidebar',
  'FAQs link in sidebar',
  'FAQs',
  'よくある質問'
)

create_content(
  'sidebar.office_timing',
  'sidebar',
  'Office timing label in sidebar',
  'Office Timing',
  '営業時間'
)

create_content(
  'sidebar.open_timing',
  'sidebar',
  'Open timing label',
  'Open',
  '営業'
)

create_content(
  'sidebar.close_timing',
  'sidebar',
  'Close timing label',
  'Close',
  '閉店'
)

create_content(
  'sidebar.open_time',
  'sidebar',
  'Office hours text',
  'Mon-Fri (10am - 5pm)',
  '月〜金（10時〜17時）'
)

create_content(
  'sidebar.holiday',
  'sidebar',
  'Holiday text',
  'Sat, Sun, Holiday',
  '土、日、祝日'
)

create_content(
  'sidebar.instructions',
  'sidebar',
  'Instructions link in sidebar',
  'Instructions',
  '設置方法'
)

create_content(
  'sidebar.samples',
  'sidebar',
  'Samples link in sidebar',
  'Samples',
  'サンプル'
)

# Sidebar YouTube and Gallery Images
puts "\nCreating Sidebar YouTube & Gallery Images..."
create_content(
  'sidebar.youtube_link',
  'sidebar',
  'YouTube video URL for sidebar',
  '',
  ''
)

create_content(
  'sidebar.gallery_image_1',
  'sidebar',
  'Main instruction image URL (links to /instructions page)',
  '',
  ''
)

create_content(
  'sidebar.gallery_image_2',
  'sidebar',
  'Shipping info image URL (links to /shipping-info page)',
  '',
  ''
)

create_content(
  'sidebar.gallery_image_3',
  'sidebar',
  'Samples image URL (opens samples modal)',
  '',
  ''
)

create_content(
  'sidebar.gallery_image_4',
  'sidebar',
  'Gallery image 4 URL (optional)',
  '',
  ''
)

create_content(
  'sidebar.gallery_image_5',
  'sidebar',
  'Bottom gallery image URL (links to /virtual-showroom page)',
  '',
  ''
)

puts "\n✓ Content seeding completed!"
puts "Total content entries: #{Content.count}"

