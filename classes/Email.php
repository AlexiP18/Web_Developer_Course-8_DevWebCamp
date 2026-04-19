<?php

namespace Classes;

use PHPMailer\PHPMailer\PHPMailer;

class Email {

    public $email;
    public $nombre;
    public $token;
    
    public function __construct($email, $nombre, $token)
    {
        $this->email = $email;
        $this->nombre = $nombre;
        $this->token = $token;
    }

    private function configurarMailer() : PHPMailer {
        $mail = new PHPMailer();
        $mail->isSMTP();
        $mail->Host = $_ENV['SMTP_HOST'] ?? ($_ENV['EMAIL_HOST'] ?? 'smtp.sendgrid.net');
        $mail->SMTPAuth = true;
        $mail->Port = (int) ($_ENV['SMTP_PORT'] ?? ($_ENV['EMAIL_PORT'] ?? 587));
        $mail->Username = $_ENV['SMTP_USER'] ?? ($_ENV['EMAIL_USER'] ?? 'apikey');
        $mail->Password = $_ENV['SMTP_PASS'] ?? ($_ENV['EMAIL_PASS'] ?? '');
        $mail->SMTPSecure = $_ENV['SMTP_SECURE'] ?? ($_ENV['EMAIL_SECURE'] ?? PHPMailer::ENCRYPTION_STARTTLS);
        $mail->SMTPAutoTLS = true;

        $mail->setFrom(
            $_ENV['MAIL_FROM_ADDRESS'] ?? ($_ENV['SMTP_FROM'] ?? ($_ENV['EMAIL_FROM'] ?? 'no-reply@devwebcamp.com')),
            $_ENV['MAIL_FROM_NAME'] ?? ($_ENV['SMTP_FROM_NAME'] ?? ($_ENV['EMAIL_FROM_NAME'] ?? 'DevWebCamp'))
        );

        $mail->isHTML(true);
        $mail->CharSet = 'UTF-8';

        return $mail;
    }

    public function enviarConfirmacion() {

         $mail = $this->configurarMailer();
         $mail->addAddress($this->email, $this->nombre);
         $mail->Subject = 'Confirma tu Cuenta';

         $contenido = '<html>';
         $contenido .= "<p><strong>Hola " . $this->nombre .  "</strong> Has Registrado Correctamente tu cuenta en DevWebCamp; pero es necesario confirmarla</p>";
         $contenido .= "<p>Presiona aquí: <a href='" . $_ENV['HOST'] . "/confirmar-cuenta?token=" . $this->token . "'>Confirmar Cuenta</a>";       
         $contenido .= "<p>Si tu no creaste esta cuenta; puedes ignorar el mensaje</p>";
         $contenido .= '</html>';
         $mail->Body = $contenido;

         //Enviar el mail
         $mail->send();

    }

    public function enviarInstrucciones() {

        $mail = $this->configurarMailer();
        $mail->addAddress($this->email, $this->nombre);
        $mail->Subject = 'Reestablece tu password';

        $contenido = '<html>';
        $contenido .= "<p><strong>Hola " . $this->nombre .  "</strong> Has solicitado reestablecer tu password, sigue el siguiente enlace para hacerlo.</p>";
        $contenido .= "<p>Presiona aquí: <a href='" . $_ENV['HOST'] . "/reestablecer?token=" . $this->token . "'>Reestablecer Password</a>";        
        $contenido .= "<p>Si tu no solicitaste este cambio, puedes ignorar el mensaje</p>";
        $contenido .= '</html>';
        $mail->Body = $contenido;

        //Enviar el mail
        $mail->send();
    }
}
