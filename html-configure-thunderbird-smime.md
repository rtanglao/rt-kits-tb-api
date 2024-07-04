html \"

:::::: {for\"\"="" data-for="" not="" tb128\"\"=""}
::: {warning\"\"=""}
WARNING: This feature is curently being developed. It is scheduled to be
released in Thunderbird 128. This feature is not supported until 128 is
released which is currently planned for summer 2024.
:::

Obtaining a personal S/MIME certificate is a multi-step process:

::: {toc\"\"=""}
## Table of Contents

-   [[1]{tocnumber\"\"=""} [Create your public and secret
    key]{toctext\"\"=""}](){#w_create-your-public-and-secret-key\"\"=""}
-   [[2]{tocnumber\"\"=""} [Get a certificate using your public key from
    your Certificate Authority
    (CA)]{toctext\"\"=""}](){#w_get-a-certificate-using-your-public-key-from-your-certificate-authority-ca\"\"=""}
-   [[3]{tocnumber\"\"=""} [Import the certificate into Certificate
    Manager and back it
    up]{toctext\"\"=""}](){#w_import-the-certificate-into-certificate-manager-and-back-it-up\"\"=""}
-   [[4]{tocnumber\"\"=""} [Configure Thunderbird to use S/MIME
    security]{toctext\"\"=""}](){#w_configure-thunderbird-to-use-smime-security\"\"=""}
:::

# Create your public and secret key {#create-your-public-and-secret-key w_create-your-public-and-secret-key\"\"=""}

A personal certificate is required for using end-to-end encryption and
digital signatures with the S/MIME technology.

A certificate consists of a key pair: a secret key and a public key. The
keys will be randomly created by Thunderbird. The private key will be
stored by Thunderbird, optionally protected by the [Primary
Password](){en-us="" kb=""
protect-your-thunderbird-passwords-primary-password\"\"=""}. The public
key will be included in the certificate. Before you get your
certificate, the public key must be submitted to a *Certificate
Authority* (CA) as part of a *Certificate Signing Request* (CSR), which
Thunderbird will create for you.

1.  Click [≡]{button\"\"=""} \> [Account Settings]{menu\"\"=""}\>
    [End-To-End Encryption]{menu\"\"=""} for the desired email account
    or identity.
2.  Scroll down to **S/MIME**: click [Generate and save a CSR file
    as...]{button\"\"=""}

First, select a directory and a filename for the CSR text. Take note of
the directory and the filename because in the next step, [Get a
certificate using your public key from your Certificate Authority
(CA)](){#w_get-a-certificate-using-your-public-key-from-your-certificate-authority-ca\"\"=""},
you will submit this file to a CA.

Second, you will be asked several questions about the cryptographic type
and strength of the S/MIME certificate that you wish to obtain. Use the
defaults unless you are an expert with specific requirements.

After you have answered all the questions, Thunderbird will randomly
generate a new key pair. Please be patient. This is an intensive
calculation process. During the process, Thunderbird may appear to be
stuck for a few seconds, but it should be done within a minute on modern
computers.

Thunderbird will show a confirmation after the operation has completed.

# Get a certificate using your public key from your Certificate Authority (CA) {#get-a-certificate-using-your-public-key-from-your-certificate-authority-ca w_get-a-certificate-using-your-public-key-from-your-certificate-authority-ca\"\"=""}

The next step is to contact a CA of your choice. If you are associated
with a company or an organization, you may wish to ask your staff which
CA you should use. If you are acting as an individual, you may wish to
search the web for CAs that issue S/MIME certificates and that accept a
CSR (At this time, Thunderbird does not recommend any specific CA).

The process to obtain a certificate may require you to set up a user
account with a CA, register your personal details, set up a payment
method, and usually requires verification of your email address.

Eventually, the CA should ask you to submit your CSR. At this point,
open the file from the previous step, \"\"Create your public and secret
key\"\", that Thunderbird had saved earlier. Your computer should show
you the contents of the file. The first line of the file will contain
the text: \"\"`-----BEGIN CERTIFICATE REQUEST-----`\"\".

Please select the full contents of the file, and use the copy command to
copy all of the text. Then navigate back to your CA\'s website (for
example to the web form in your browser, on the CA\'s web page, which
asks you to submit the CSR), and paste the text, and continue.

After you have submitted your file successfully to the CA, it should
notify you that the certificate has been issued or will be issued soon.
It may offer you the certificate for download immediately or at a later
time, or send it to you by email.

Save the certificate file you have received from your CA to and remember
where you saved it. If you are using Firefox, it will be saved in the
download directory configured in your Firefox settings (e.g. your
**Downloads** folder).

If you are downloading from a web page using your browser, check whether
that page lists additional intermediate certificates, which you also
might have to download.

::: {note\"\"=""}
Note: If the CA is delivering the certificate to you in a file with a
filename extension *.p12* or *.pfx*, it may indicate that the CA did not
use the key that you had submitted, but rather generated a secret key on
their systems. This may not be what you want.
:::

# Import the certificate into Certificate Manager and back it up {#import-the-certificate-into-certificate-manager-and-back-it-up w_import-the-certificate-into-certificate-manager-and-back-it-up\"\"=""}

1.  Click [≡]{button\"\"=""} \> [Account Settings]{menu\"\"=""}\>
    [End-To-End Encryption]{menu\"\"=""} for the email account or
    identity you used earlier.
2.  Click [Manage S/MIME Certificates]{button\"\"=""}. If the
    **Certificate Manager** window is too small, drag its lower right
    corner to increase the window size.
3.  **Certificate Manager** has five tabs at the top. Click the
    [People]{button\"\"=""} tab \> [Import]{button\"\"=""} button at the
    bottom. Select the file that you have obtained from the CA, and
    confirm. If the import was successful, no further information will
    be shown, you will simply return to the Certificate Manager window.
    Because Thunderbird has stored the corresponding secret key (created
    during the initial steps of this process), Thunderbird should have
    been able to combine it with the certificate you just imported.
4.  If your CA offered you additional intermediate (or subordinate)
    certificates to download, click the [Authorities]{button\"\"=""}
    tab, click the [Import]{button\"\"=""} button, and import them one
    after the other. Note that when importing a CA in this place,
    Thunderbird will offer you to mark a CA as trusted, and also warn
    you about the associated risks. Please leave the checkboxes
    unchecked, do NOT check them. Confirm by clicking
    [OK]{button\"\"=""} which will import the intermediate CA
    certificate without explicitly trusting it. (Explanation: It isn\'t
    necessary to assign explicit trust to an intermediate certificate,
    as it is used only to discover a pathway from a person\'s
    certificate to a trusted root CA certificate.)
5.  Still in **Certificate Manager**, click [Your
    Certificates]{button\"\"=""}. You should see your new personal
    certificate in the list.
6.  Before you exit the **Certificate Manager**, it is crucial to
    securely backup your key and certificate to a different disk:
    1.  Select the entry that shows your new personal certificate, and
        click [Backup]{button\"\"=""}.
    2.  Select the directory and the filename in which the backup will
        be stored.
    3.  Then, follow the steps shown on screen, which includes defining
        a password of your choice to protect the backup file, to
        complete the backup procedure. Make sure to save the backup file
        to an appropriate location, such as a flash drive on which you
        keep important backups, and save the password somewhere secure
        like your password manager.

# Configure Thunderbird to use S/MIME security {#configure-thunderbird-to-use-smime-security w_configure-thunderbird-to-use-smime-security\"\"=""}

1.  Click [≡]{button\"\"=""} \> [Account Settings]{menu\"\"=""}\>
    [End-To-End Encryption]{menu\"\"=""} for the email account or
    identity you used earlier.
2.  In the section below the **S/MIME heading**, you will find two
    selection boxes labeled **Personal certificate for digital signing**
    and **Personal certificate for encryption**. Click the
    [Select\...]{button\"\"=""} button on the right.
3.  A list will be shown with your personal certificates for this email
    address. The certificate that you have just obtained should be
    offered in that list. Select it and confirm it. Thunderbird may ask
    you to use the same certificate for both encryption and signing,
    which usually you should confirm.

Now you should be able to use your personal certificate for sending
digitally signed email. Recipients of your signed email should be able
to send you encrypted email using the S/MIME technology, as long as the
certificate has not expired. Once the certificate expires, you will have
to repeat the procedure to obtain a new personal certificate.
::::::

\"
