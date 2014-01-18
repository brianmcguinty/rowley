Deface::Override.new(:virtual_path      => "spree/layouts/spree_application",
                    :name               => "add_live_chat",
                    :insert_bottom   => "[data-hook='inside_head'], #homepage_products[inside_head]",
                    :erb				=> %q{<script type="text/javascript">
                    var __lc = {};
                    __lc.license = 2595711;
                    (function() {
                    var lc = document.createElement('script'); lc.type = 'text/javascript'; lc.async = true;
                    lc.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'cdn.livechatinc.com/tracking.js';
                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(lc, s);
                    })();
                    </script>},

                    :disabled           => false)

Deface::Override.new(:virtual_path      => "spree/layouts/rowleycare_layout",
                    :name               => "add_live_chat_rc",
                    :insert_bottom   => "[data-hook='inside_head'], #homepage_products[inside_head]",
                    :erb				=> %q{<script type="text/javascript">
                    var __lc = {};
                    __lc.license = 2595711;
                    (function() {
                    var lc = document.createElement('script'); lc.type = 'text/javascript'; lc.async = true;
                    lc.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'cdn.livechatinc.com/tracking.js';
                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(lc, s);
                    })();
                    </script>},

                    :disabled           => false)

Deface::Override.new(:virtual_path      => "spree/layouts/mrpowers_rowley_care_layout",
                    :name               => "add_live_chat_rc_powers",
                    :insert_bottom   => "[data-hook='inside_head'], #homepage_products[inside_head]",
                    :erb				=> %q{<script type="text/javascript">
                    var __lc = {};
                    __lc.license = 2595711;
                    (function() {
                    var lc = document.createElement('script'); lc.type = 'text/javascript'; lc.async = true;
                    lc.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'cdn.livechatinc.com/tracking.js';
                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(lc, s);
                    })();
                    </script>},

                    :disabled           => false)

Deface::Override.new(:virtual_path      => "spree/layouts/rowleytryon_layout",
                    :name               => "add_live_chat_hto",
                    :insert_bottom   => "[data-hook='inside_head'], #homepage_products[inside_head]",
                    :erb				=> %q{<script type="text/javascript">
                    var __lc = {};
                    __lc.license = 2595711;
                    (function() {
                    var lc = document.createElement('script'); lc.type = 'text/javascript'; lc.async = true;
                    lc.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'cdn.livechatinc.com/tracking.js';
                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(lc, s);
                    })();
                    </script>},

                    :disabled           => false)
