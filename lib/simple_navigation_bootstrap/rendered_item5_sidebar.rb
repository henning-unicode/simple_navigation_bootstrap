# frozen_string_literal: true

module SimpleNavigationBootstrap
  class RenderedItem5Sidebar < RenderedItem

    private

      def li_link # ruboc:disable Metrics/AbcSize, Metrics/MethodLength
        if navbar_text
          li_navbar_text
        elsif divider
          li_divider
        elsif header && (level != 1)
          li_header
        else
          li_button_or_link
        end
      end

      def li_navbar_text
        content_tag(:li, content_tag(:p, item.name, class: 'navbar-text'), options)
      end

      def li_divider
        options[:class] = [options[:class], 'border-top', 'my-3'].flatten.compact.join(' ')
        content_tag(:li, '', options)
      end

      def li_header
        css_class = @bootstrap_version == 3 ? 'dropdown-header' : 'nav-header'
        options[:class] = [options[:class], css_class].flatten.compact.join(' ')
        content_tag(:li, item.name, options)
      end

      def li_button_or_link
        if include_sub_navigation?(item)
          if level == 1
            if split
              splitted_simple_part + splitted_dropdown_part
            else
              li_with_collapse_button
            end
          else
            content_tag(:li, submenu_link, options)
          end
        else
          content_tag(:li, simple_link, options)
        end
      end

      def li_with_collapse_button
        options[:class] = [options[:class], 'mb-1'].flatten.compact.join(' ')
        
        button_content = [item.name]
        button_content << caret unless skip_caret
        button_content = button_content.join(' ').html_safe
        
        button = collapse_button(button_content)
        collapse_div = collapse_div_for(item)
        
        content_tag(:li, button + collapse_div, options)
      end

      def collapse_button(name)
        btn_options = {
          class: ['btn', 'btn-toggle', 'd-inline-flex', 'align-items-center', 'rounded', 'border-0'],
          'data-bs-toggle' => 'collapse',
          'aria-expanded' => 'false',
          type: 'button'
        }
        
        btn_options[:class] = btn_options[:class].flatten.compact.join(' ')
        btn_options[:class] += ' collapsed' if !item.selected?
        btn_options[:'aria-expanded'] = 'true' if item.selected?
        
        if item.key
          btn_options[:'data-bs-target'] = "##{item.key}-collapse"
        end
        
        content_tag(:button, name, btn_options)
      end

      def collapse_div_for(item)
        div_options = {
          class: ['collapse'],
          id: "#{item.key}-collapse"
        }
        
        div_options[:class] = div_options[:class].flatten.compact.join(' ')
        div_options[:class] += ' show' if item.selected?
        
        inner_ul = content_tag(:ul, render_sub_items(item), class: 'btn-toggle-nav list-unstyled fw-normal pb-1 small')
        content_tag(:div, inner_ul, div_options)
      end

      def render_sub_items(item)
        item.sub_navigation.items.map do |sub_item|
          content_tag(:li, submenu_link_for(sub_item))
        end.join
      end

      def submenu_link
        submenu_link_for(item)
      end

      def submenu_link_for(sub_item)
        link_options = sub_item.link_html_options || {}
        link_class = ['link-body-emphasis', 'd-inline-flex', 'text-decoration-none', 'rounded']
        link_options[:class] = [link_options[:class], link_class].flatten.compact.join(' ')
        link_options[:method] ||= sub_item.method
        url = sub_item.url || '#'
        link_to(sub_item.name, url, link_options)
      end

      def caret
        content_tag(:span, '', class: 'caret')
      end

      def simple_link
        link_class = ['link-body-emphasis', 'd-inline-flex', 'text-decoration-none', 'rounded']
        link_class = [link_class, 'active'].join(' ') if item.selected?
        link_options[:class] = [link_options[:class], link_class].flatten.compact.join(' ')
        link_options[:method] ||= item.method
        link_options[:'aria-current'] = 'page' if item.selected?
        url = item.url || '#'
        link_to(item.name, url, link_options)
      end

      def splitted_simple_part
        main_li_options = options.dup
        main_li_options[:class] = [main_li_options[:class], 'mb-1'].flatten.compact.join(' ')
        content_tag(:li, simple_link, main_li_options)
      end

      def splitted_dropdown_part
        btn_options = {
          class: ['btn', 'btn-toggle', 'd-inline-flex', 'align-items-center', 'rounded', 'border-0'],
          'data-bs-toggle' => 'collapse',
          'aria-expanded' => 'false',
          type: 'button'
        }
        btn_options[:class] = btn_options[:class].flatten.compact.join(' ')
        btn_options[:'aria-expanded'] = 'true' if item.selected?
        btn_options[:'data-bs-target'] = "##{item.key}-collapse" if item.key
        
        button = content_tag(:button, caret, btn_options)
        collapse_div = collapse_div_for(item)
        
        split_options = options.dup
        split_options[:class] = [split_options[:class], 'mb-1'].flatten.compact.join(' ')
        content_tag(:li, button + collapse_div, split_options)
      end

  end
end
