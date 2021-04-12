class UserMailer < ApplicationMailer
  def paper_invitation_mail(paper, user)
    @paper = paper
    @user = user

    if user.needs_invitation?
      @temporary_password = user.assign_temporary_password
    end

    subject = (paper.owner == user) ?
                  I18n.t('mailer.owner_subject') :
                  "CIIE - Has sido añadido como #{@paper.collaborator_name} en la ponencia #{@paper.name}."

    mail(to: user.email, subject: subject)
  end

  def evaluator_invitation_mail(evaluator)
    @evaluator = evaluator
    @temporary_password = evaluator.assign_temporary_password

    subject = "CIIE - Instrucciones para la evaluación de contribuciones en la convocatoria 2020"

    mail(to: evaluator.email, subject: subject)
  end
end
