# frozen_string_literal: true

module Legion
  module Extensions
    module Slack
      module Runners
        module Blocks
          def mrkdwn(text)
            { type: 'mrkdwn', text: text }
          end

          def plain_text(text, emoji: true)
            { type: 'plain_text', text: text, emoji: emoji }
          end

          def option(text:, value:)
            { text: plain_text(text), value: value }
          end

          def section(text:, accessory: nil, fields: nil)
            block = { type: 'section', text: mrkdwn(text) }
            block[:accessory] = accessory if accessory
            block[:fields] = fields if fields
            block
          end

          def divider
            { type: 'divider' }
          end

          def header(text:)
            { type: 'header', text: plain_text(text) }
          end

          def context(elements:)
            { type: 'context', elements: elements }
          end

          def actions(elements:, block_id: nil)
            block = { type: 'actions', elements: elements }
            block[:block_id] = block_id if block_id
            block
          end

          def image(image_url:, alt_text:, title: nil, block_id: nil)
            block = { type: 'image', image_url: image_url, alt_text: alt_text }
            block[:title] = plain_text(title) if title
            block[:block_id] = block_id if block_id
            block
          end

          def input(label:, element:, block_id: nil, optional: false, dispatch_action: false)
            block = { type: 'input', label: plain_text(label), element: element,
                      optional: optional, dispatch_action: dispatch_action }
            block[:block_id] = block_id if block_id
            block
          end

          def file_block(external_id:, block_id: nil)
            block = { type: 'file', external_id: external_id, source: 'remote' }
            block[:block_id] = block_id if block_id
            block
          end

          def button(text:, action_id:, value: nil, style: nil, url: nil)
            el = { type: 'button', text: plain_text(text), action_id: action_id }
            el[:value] = value if value
            el[:style] = style if style
            el[:url] = url if url
            el
          end

          def overflow_menu(action_id:, options:)
            { type: 'overflow', action_id: action_id, options: options }
          end

          def static_select(action_id:, placeholder:, options:)
            { type: 'static_select', action_id: action_id,
              placeholder: plain_text(placeholder), options: options }
          end

          def multi_static_select(action_id:, placeholder:, options:)
            { type: 'multi_static_select', action_id: action_id,
              placeholder: plain_text(placeholder), options: options }
          end

          def datepicker(action_id:, placeholder: nil, initial_date: nil)
            el = { type: 'datepicker', action_id: action_id }
            el[:placeholder] = plain_text(placeholder) if placeholder
            el[:initial_date] = initial_date if initial_date
            el
          end
        end
      end
    end
  end
end
