class Answer
	# 提问方法传入要提问的内容
	def self.questions(question)
		# 把输入问题装换成Unicode格式
		question = Rack::Utils.escape(question)
		res = RestClient.get("http://api.jisuapi.com/iqa/query?appkey=ba973cb13401dd26&question=#{question}")
		# puts res.code
		# result = JSON.parse(res.body)
		# puts result["result"]["content"]
		# puts '---------------'
		# 先判断请求是否发送成功
		if res.code == 200
			# 发送成功返回参数 json格式化
			result = JSON.parse(res.body)
			# 判断返回内容格式是否正确 正确就返回
			if result["status"] == '0' && result["msg"] == "ok"
				return result["result"]["content"]
			else
				# 不正确就返回接口数据异常
				{status: -1,notice: '智能问答接口数据异常'}
			end
		else
			#请求失败说明网络问题
			{status:-2, notice: '网络异常'}
		end
	end
end