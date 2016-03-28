
"use strict";


$( document ).ready( function() {



  // Ajoute target="_blank" aux liens externes.
  ( function() {
    var internal = location.host.replace( "www.", "" );
    internal = new RegExp( internal, "i" );
    var a = document.getElementsByTagName( 'a' );
    for( var i = 0; i < a.length; i++ ) {
      var href = a[ i ].host;
      if( !internal.test( href ) ) {
        a[ i ].setAttribute( 'target', '_blank' );
      }
    }
  })();



  // Navigation page suivante ou précédente avec les flèches
  // gauche-droite du clavier.
  ( function() {
    Mousetrap.bind( 'left',  function(e) { navigate_prev_page(); });
    Mousetrap.bind( 'esc',   function(e) { navigate_home_page(); });
    Mousetrap.bind( 'right', function(e) { navigate_next_page(); });
    function navigate_next_page() {
       var next_page = $( ".bouton-suiv" ).first().attr( "href" );
       window.location.href = next_page;
    }
    function navigate_home_page() {
       var prev_page = $( ".bouton-accueil" ).first().attr( "href" );
       window.location.href = prev_page;
    }
    function navigate_prev_page() {
       var prev_page = $( ".bouton-prec" ).first().attr( "href" );
       window.location.href = prev_page;
    }
  })();



  // Formulaire de contact.
  ( function() {
    var $contactForm = $( '#contact-form' );
    $contactForm.submit( function(e) {
      e.preventDefault();
      var $form_status = $( '#form-status' );
      $form_status.removeClass( "hidden" );

      // Vérifie que tous les champs sont remplis
      var form_email_length   = $( '#form-email' ).val().length;
      var form_nom_length     = $( '#form-nom' ).val().length;
      var form_message_length = $( '#form-message' ).val().length;
      if( form_email_length == 0 || form_nom_length == 0 || form_message_length == 0 ) {
        $form_status.html( '<div class="alert alert-danger" role="alert"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> Veuillez remplir tous les champs <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span></div>' );
        return;
      }

      $.ajax({
        url: $( '#contact-form' ).attr( "action" ),
        method: 'POST',
        data: $( this ).serialize(),
        dataType: 'json',
        beforeSend: function() {
          $form_status.html( '<div class="alert alert-info" role="alert">Envoi du message</div>' );
        },
        success: function(data) {
          $form_status.html( '<div class="alert alert-success" role="alert">Message envoyé, merci !</div>' );
          $( '#form-submit-button' ).prop( "disabled", true );
          $( '#form-email' ).val( '' );
          $( '#form-nom' ).val( '' );
          $( '#form-message' ).val( '' );
        },
        error: function(err) {
          $form_status.html( '<div class="alert alert-danger" role="alert">Il y a eu une erreur !</div>' );
        }
      });
    });
  })();



});