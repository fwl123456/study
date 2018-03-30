class Weather
  def self.get_weather(city)
  	city = ERB::Util.url_encode(city) # 把中文编码成url_encode
  	# 传入城市名后发送get请求调用接口查询出天气返回给res
  	res = RestClient.get("http://v.juhe.cn/weather/index?cityname=#{city}&key=ab63850bdec84b98f1f890eb9a717147")
  	if res.code == 200 #判断如果请求返回响应值==200
  	# 把天气对象里面的body部分转换成json格式给result
  		result = JSON.parse(res.body)
  	# 判断如果返回的result结果集里的resultcode等于'200'
	  	if result["resultcode"] == '200'
	  # 只返回result里面中的today(在result中取出result中的today)
	  		return result["result"]["today"]
	  	else
	  # 如果result结果集里面的resultcode不等于200，那么返回状态码-1，接口数据异常
	  		{status: -1,notice: 'weather接口数据异常'}
	  	end
	  else
	  # 如果http响应值不是200，那么返回网络异常
	  	{status:-2, notice: '网络异常'}
  	end
  end
end