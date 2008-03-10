
class DemoUser
  
  def self.reset
    @seed = User.find_by_email 'seed@homemarks.com'
    @demo = User.find_by_email 'demo@homemarks.com'
    User.transaction do
      Inboxmark.delete_all "inbox_id = #{@demo.inbox.id}"
      Trashboxmark.delete_all "trashbox_id = #{@demo.trashbox.id}"
      Column.delete_all "user_id = #{@demo.id}"
      for seed_col in @seed.columns.reverse
        demo_col = @demo.columns.create(seed_col.attributes)
        for swawn_box in seed_col.boxes.reverse
          demo_box = demo_col.boxes.create(swawn_box.attributes)
          for seed_bookmark in swawn_box.bookmarks.reverse
            demo_box.bookmarks.create(seed_bookmark.attributes)
          end
        end
      end
      for seed_inboxmark in @seed.inbox.bookmarks.reverse
        @demo.inbox.bookmarks.create(seed_inboxmark.attributes)
      end
      for seed_trashboxmark in @seed.trashbox.bookmarks.reverse
        @demo.trashbox.bookmarks.create(seed_trashboxmark.attributes)
      end
      FileUtils.rm_r(File.join(RAILS_ROOT, "tmp/cache/user/#{@demo.id}"))
    end
  end
  
end

