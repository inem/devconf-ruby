class Asset < ActiveRecord::Base
  self.table_name = 'asset'
  belongs_to :image

end
