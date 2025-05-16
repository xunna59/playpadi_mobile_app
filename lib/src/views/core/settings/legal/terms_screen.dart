import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  final String termsText = '''
PLAYPADI TERMS AND CONDITIONS

1. Identification of the owner and general information
The ownership of this Website shop.playtomic.com/en/ ((hereinafter, the Website) is PLAYTOMIC, S.L. (hereinafter, PLAYTOMIC), with NIF [Spanish Tax ID No.]: B-84604792 and registered office at Paseo de la Castellana 93, 10 – Edificio Cadaguamadrid 28046 Madrid, and registered at: Madrid Business Register; and its registration details are: volume 35650, Book 0, Folio 84, Section 8, Page M-430240.

This document (as well as all the other documents mentioned here) governs the conditions that regulate the use of this Website and the purchase or acquisition of products on the same (hereinafter, Conditions).
For the purpose of these Conditions it is understand that the activity that Playtomic is undertaking via the Website includes: Marketing women's and men's sports clothing and accessories.

In addition to reading these conditions, before accessing, navigating and/or using this web page, the User must have read the Playtomic cookies policy and the privacy and data protection policies. When purchasing a product via the Website and ticking the relevant box in acceptance of these terms, the User agrees to be bound by these Conditions and for all the above and this remains no less valid than a handwritten signature.

Please be informed that these Conditions may be modified. The User is responsible for consulting them each time that they access, navigate and/or use the Website, since those in force at the time that the acquisition of products and/or services is made will apply.

For any questions that the User may have in relation to the Conditions, they may contact the owner by using the contact details provided above, or where appropriate, by using the contact form or via the email address apparel@playtomic.io

2. The User
The access, navigation and use of the Website confers the condition of user (hereinafter referred indistinctly and individually as User or jointly as Users).
The User assumes their responsibility of the correct use of the Website. This responsibility will include:
Hacer uso de este Sitio Web únicamente para realizar consultas y compras o adquisiciones legalmente válidas.
Not making any false or fraudulent purchases. If it could be reasonably considered that a purchase of this nature has been made, it may be cancelled and reported to the relevant authorities.
Providing true and lawful contact details such as an email address, postal address and/or other details.
The User states that they are above 18 years old and have the legal capacity to enter into agreements via this Website.
This Website is aimed primarily at Users residing in Europe. Playtomic does not guarantee that the Website complies with legislation in other countries, either fully or partially. Playtomic accepts no responsibility that may arise from the said access, nor does it guarantee the provision of goods or services outside of Europe.

The User may formalise the purchase agreement with Playtomic for the desired products in any of the languages that these conditions are available in on this Website, according to their choice.

Users are not required to register to access the Website, although a user's details will be requested when any purchase is made, with the option to register and create a user account.

3. Purchasing process
The opportunity to purchase sports clothing and other accessories is offered to users via the PLAYTOMIC Website. To make the purchase, users must follow the purchasing procedure on the Website, during which several products can be selected and added to the cart or basket, so that payment can be subsequently made.

The user may create a user account or purchase as a guest. The User must complete and/or check the information that is requested at each step, during the purchasing process, before completing the payment.\

The User will then receive an email confirming that Playtomic has received their purchase order, that is, the order confirmation. Where appropriate, this information may also be made available to the user via their user account.
In accordance with the provisions of the applicable legislation, agreements entered into electronically will have all the effects provided for in the legal system when consent and the other requirements necessary for its validity are agreed.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of use',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            termsText,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ),
    );
  }
}
