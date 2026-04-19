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

    private function env(string $key, string $default = '') : string {
        if (isset($_ENV[$key]) && $_ENV[$key] !== '') {
            return (string) $_ENV[$key];
        }

        if (isset($_SERVER[$key]) && $_SERVER[$key] !== '') {
            return (string) $_SERVER[$key];
        }

        $value = getenv($key);
        if ($value !== false && $value !== '') {
            return (string) $value;
        }

        return $default;
    }

    private function configurarMailer() : PHPMailer {
        $mail = new PHPMailer();
        $mail->isSMTP();
        $mail->Host = $this->env('SMTP_HOST', $this->env('EMAIL_HOST', 'smtp.sendgrid.net'));
        $mail->SMTPAuth = true;
        $mail->Port = (int) $this->env('SMTP_PORT', $this->env('EMAIL_PORT', '587'));
        $mail->Username = $this->env('SMTP_USER', $this->env('EMAIL_USER', 'apikey'));
        $mail->Password = $this->env('SMTP_PASS', $this->env('EMAIL_PASS', ''));
        $mail->SMTPSecure = $this->env('SMTP_SECURE', $this->env('EMAIL_SECURE', PHPMailer::ENCRYPTION_STARTTLS));
        $mail->SMTPAutoTLS = true;

        $mail->setFrom(
            $this->env('MAIL_FROM_ADDRESS', $this->env('SMTP_FROM', $this->env('EMAIL_FROM', 'no-reply@devwebcamp.com'))),
            $this->env('MAIL_FROM_NAME', $this->env('SMTP_FROM_NAME', $this->env('EMAIL_FROM_NAME', 'DevWebCamp')))
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
         $contenido .= "<p>Presiona aquí: <a href='" . $this->env('HOST') . "/confirmar-cuenta?token=" . $this->token . "'>Confirmar Cuenta</a>";       
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
        $contenido .= "<p>Presiona aquí: <a href='" . $this->env('HOST') . "/reestablecer?token=" . $this->token . "'>Reestablecer Password</a>";        
        $contenido .= "<p>Si tu no solicitaste este cambio, puedes ignorar el mensaje</p>";
        $contenido .= '</html>';
        $mail->Body = $contenido;

        //Enviar el mail
        $mail->send();
    }
}
