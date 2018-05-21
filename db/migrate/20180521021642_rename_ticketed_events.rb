class RenameTicketedEvents < ActiveRecord::Migration[5.2]
  def change
    rename_table :ticketed_event, :ticketed_events
  end
end
