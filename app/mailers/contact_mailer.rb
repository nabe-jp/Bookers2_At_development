class ContactMailer < ApplicationMailer

  # グループメンバー全員にメールを送信するメソッド
  def send_mail(group, mail_title, mail_content, group_users)
    @group = group
    @mail_title = mail_title
    @mail_content = mail_content
    mail bcc: group_users.pluck(:email), subject: mail_title
    end
  end
