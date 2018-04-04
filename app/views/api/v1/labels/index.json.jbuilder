json.label @labels do |label|
	json.id label.id.to_s
	json.name label.name
	json.article_ids label.article_ids
end