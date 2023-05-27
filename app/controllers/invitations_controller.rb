# invitation
class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def get_url(p_type, p_id)
    Invitation.find_by(type: p_type, this_id: p_id)
  end

  def invite
    params = invite_params
    url = get_url(params[:type], params[:this_id])
    if url && (params[:change] == false)
      {
        exist: true,
        url: url
      }
    end
    # # なかったとき
    # URLを生成する
    secret = SecureRandom::hex(128)
    message = "workspace#{self.id}Pass#{secret}"
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    encrypt_message = encryptor.encrypt_and_sign(message)

    url = request.base_url + '/workspaces/invite/confirm?crypt_text=' + encrypt_message
    Invitation.create({
                        type: 'workspace',
                        this_id: self.id,
                        plain_text: encrypt_message,
                        password_digest: secret
                      })
    # return
    {
      exist: false,
      url: url
    }
  end

  def create
    params = create_params
    invitation = Invitation.create!({
                                      type: params[:type],
                                      this_id: params[:this_id],
                                      plain_text: params[:plain_text],
                                      password_digest: params[:password_digest]
                                    })

    if invitation
      render status: 200, json: invitation
    else
      render status: 400, json: { status: "cannot create invitation" }
    end
  end

  private

  def invite_params
    params.permit(:type, :this_id, :change)
  end

  def create_params
    params.permit(:type, :this_id, :plain_text, :password_digest, :is_deleted)
  end

end