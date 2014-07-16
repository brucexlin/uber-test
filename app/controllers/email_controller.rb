class EmailController < ApplicationController

  def deliver
    if MailerService.new(params).deliver
      flash[:notice] = 'Thank you for testing our mailer service!'
    else
      flash[:error] = 'Email delivery failed, please fill the correct information and try again.'
    end

    redirect_to root_url
  end

end
