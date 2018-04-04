json.article @articles do |article|
	json.id article.id.to_s
	json.title article.title
	json.text article.text
	json.created_at article.created_at
	json.label_ids article.label_ids
end