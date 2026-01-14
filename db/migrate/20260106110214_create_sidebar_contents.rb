class CreateSidebarContents < ActiveRecord::Migration[7.1]
  def change
    create_table :sidebar_contents do |t|
      t.text :youtube_link
      t.text :gallery_image_1
      t.text :gallery_image_2
      t.text :gallery_image_3
      t.text :gallery_image_4
      t.text :gallery_image_5

      t.timestamps
    end
  end
  
  def data
    # Create a single default record after table is created
    SidebarContent.create!(
      youtube_link: '',
      gallery_image_1: '',
      gallery_image_2: '',
      gallery_image_3: '',
      gallery_image_4: '',
      gallery_image_5: ''
    )
  end
end
