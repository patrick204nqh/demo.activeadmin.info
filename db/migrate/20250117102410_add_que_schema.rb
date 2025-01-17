class AddQueSchema < ActiveRecord::Migration[7.2]
  def up
    Que.migrate!(version: 7)
  end

  def down
    Que.migrate!(version: 0)
  end
end
