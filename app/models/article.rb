class Article < ActiveRecord::Base
  attr_accessible :body, :title, :tag_list
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings

  def tag_list
  	#return self.tags.join(", ")
  	self.tags.collect do |tag|
  		tag.name
  	end.join(", ")
  end

  def to_s
  	name	
  end

  def tag_list=(tags_string)
  	self.taggings.detroy_all
  	#Remove all existing tags to prevent double tagging.

  	#Separate the tags by ', ' and downcase them.
  	tag_names = tags_string.split(", ").collect{|s| s.strip.downcase} .uniq
  	#.uniq removes any repeated tags.

  	tag_names.each do |tag_name|  		
	  	#Check that the tags arent already in the tags table or add them.
	  	tag = Tag.find_or_create_by_name(tag_name)
	  	#Connect the articles via the taggings table.
	  	tagging = self.taggings.new
	  	tagging.tag_id = tag.id
	  end
  end

end
