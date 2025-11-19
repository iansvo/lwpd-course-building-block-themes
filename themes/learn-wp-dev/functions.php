<?php
$is_local = strpos( get_site_url(), 'localhost' ) > -1;

add_action( 'wp_enqueue_scripts', function() use( $is_local ) {
    $is_local = strpos( get_site_url(), 'localhost' ) < -1;
    wp_enqueue_style( 'lwpd', get_stylesheet_uri(), [], $is_local ? time() : false );
} );

add_action( 'init', function() {
    register_block_style(
        'core/button',
        array(
            'name'         => 'plain',
            'label'        => __( 'Plain', 'textdomain' ),
            'style_handle' => 'lwpd',
        )
    );
} );

add_action( 'enqueue_block_assets', function() use( $is_local ) {
    wp_enqueue_style( 'lwpd', get_stylesheet_uri(), [], $is_local ? time() : false );
} );
