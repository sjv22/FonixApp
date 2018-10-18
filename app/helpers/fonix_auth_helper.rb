require 'zensend'
module FonixAuthHelper
	def api_call_to_zensend(fonix_auth)
    client = ZenSend::Client.new("3Kav64WboPY3-CSgBsDpgQ")
    begin
	  result = client.send_sms({
    	originator_type: "msisdn",
	    originator: "",
	    numbers: [fonix_auth.mobile_number],
	    body: "Your 4-digit code is: #{fonix_auth.random_code}. Enter this code to confirm your details"
	  })
	  return true
	  rescue ZenSend::ZenSendException => e
		  authentication.errors.add("There was an error. Please try again: ", e.failcode)
		  return false
	end
  end
end
