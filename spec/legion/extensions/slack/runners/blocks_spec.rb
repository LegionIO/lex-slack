# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Blocks do
  let(:test_obj) { Object.new.extend(described_class) }

  describe '#mrkdwn' do
    it 'returns mrkdwn type object' do
      result = test_obj.mrkdwn('hello')
      expect(result).to eq({ type: 'mrkdwn', text: 'hello' })
    end

    it 'sets text correctly' do
      result = test_obj.mrkdwn('*bold*')
      expect(result[:text]).to eq('*bold*')
    end
  end

  describe '#plain_text' do
    it 'returns plain_text type with emoji true by default' do
      result = test_obj.plain_text('Hello')
      expect(result).to eq({ type: 'plain_text', text: 'Hello', emoji: true })
    end

    it 'accepts emoji: false' do
      result = test_obj.plain_text('Hello', emoji: false)
      expect(result[:emoji]).to be false
    end
  end

  describe '#option' do
    it 'returns option element' do
      result = test_obj.option(text: 'Choice A', value: 'a')
      expect(result[:value]).to eq('a')
      expect(result[:text][:type]).to eq('plain_text')
    end
  end

  describe '#section' do
    it 'returns section block with mrkdwn text' do
      result = test_obj.section(text: 'Hello')
      expect(result[:type]).to eq('section')
      expect(result[:text][:type]).to eq('mrkdwn')
    end

    it 'includes accessory when provided' do
      acc = { type: 'button' }
      result = test_obj.section(text: 'Hello', accessory: acc)
      expect(result[:accessory]).to eq(acc)
    end

    it 'includes fields when provided' do
      fields = [test_obj.mrkdwn('Field 1')]
      result = test_obj.section(text: 'Hello', fields: fields)
      expect(result[:fields]).to eq(fields)
    end

    it 'omits accessory when nil' do
      result = test_obj.section(text: 'Hello')
      expect(result).not_to have_key(:accessory)
    end
  end

  describe '#divider' do
    it 'returns divider block' do
      expect(test_obj.divider).to eq({ type: 'divider' })
    end
  end

  describe '#header' do
    it 'returns header block with plain_text' do
      result = test_obj.header(text: 'Title')
      expect(result[:type]).to eq('header')
      expect(result[:text][:type]).to eq('plain_text')
      expect(result[:text][:text]).to eq('Title')
    end
  end

  describe '#context' do
    it 'returns context block with elements' do
      elements = [test_obj.mrkdwn('note')]
      result = test_obj.context(elements: elements)
      expect(result[:type]).to eq('context')
      expect(result[:elements]).to eq(elements)
    end
  end

  describe '#actions' do
    it 'returns actions block' do
      result = test_obj.actions(elements: [])
      expect(result[:type]).to eq('actions')
    end

    it 'includes block_id when provided' do
      result = test_obj.actions(elements: [], block_id: 'act1')
      expect(result[:block_id]).to eq('act1')
    end

    it 'omits block_id when nil' do
      result = test_obj.actions(elements: [])
      expect(result).not_to have_key(:block_id)
    end
  end

  describe '#image' do
    it 'returns image block' do
      result = test_obj.image(image_url: 'https://example.com/img.png', alt_text: 'An image')
      expect(result[:type]).to eq('image')
      expect(result[:image_url]).to eq('https://example.com/img.png')
    end

    it 'includes title when provided' do
      result = test_obj.image(image_url: 'https://example.com/img.png', alt_text: 'img', title: 'My Image')
      expect(result[:title][:type]).to eq('plain_text')
    end
  end

  describe '#input' do
    it 'returns input block' do
      result = test_obj.input(label: 'Name', element: { type: 'plain_text_input' })
      expect(result[:type]).to eq('input')
      expect(result[:label][:text]).to eq('Name')
    end

    it 'includes block_id when provided' do
      result = test_obj.input(label: 'Name', element: {}, block_id: 'inp1')
      expect(result[:block_id]).to eq('inp1')
    end
  end

  describe '#file_block' do
    it 'returns file block' do
      result = test_obj.file_block(external_id: 'ext123')
      expect(result[:type]).to eq('file')
      expect(result[:external_id]).to eq('ext123')
      expect(result[:source]).to eq('remote')
    end

    it 'includes block_id when provided' do
      result = test_obj.file_block(external_id: 'ext123', block_id: 'f1')
      expect(result[:block_id]).to eq('f1')
    end
  end

  describe '#button' do
    it 'returns button element' do
      result = test_obj.button(text: 'Click', action_id: 'btn1')
      expect(result[:type]).to eq('button')
      expect(result[:action_id]).to eq('btn1')
    end

    it 'includes optional fields when provided' do
      result = test_obj.button(text: 'Click', action_id: 'btn1', value: 'v1', style: 'primary', url: 'https://example.com')
      expect(result[:value]).to eq('v1')
      expect(result[:style]).to eq('primary')
      expect(result[:url]).to eq('https://example.com')
    end
  end

  describe '#overflow_menu' do
    it 'returns overflow element' do
      opts = [test_obj.option(text: 'A', value: 'a')]
      result = test_obj.overflow_menu(action_id: 'ovf1', options: opts)
      expect(result[:type]).to eq('overflow')
      expect(result[:action_id]).to eq('ovf1')
    end
  end

  describe '#static_select' do
    it 'returns static_select element' do
      result = test_obj.static_select(action_id: 'sel1', placeholder: 'Pick one', options: [])
      expect(result[:type]).to eq('static_select')
      expect(result[:placeholder][:text]).to eq('Pick one')
    end
  end

  describe '#multi_static_select' do
    it 'returns multi_static_select element' do
      result = test_obj.multi_static_select(action_id: 'msel1', placeholder: 'Pick many', options: [])
      expect(result[:type]).to eq('multi_static_select')
    end
  end

  describe '#datepicker' do
    it 'returns datepicker element' do
      result = test_obj.datepicker(action_id: 'dp1')
      expect(result[:type]).to eq('datepicker')
      expect(result[:action_id]).to eq('dp1')
    end

    it 'includes placeholder and initial_date when provided' do
      result = test_obj.datepicker(action_id: 'dp1', placeholder: 'Pick date', initial_date: '2026-01-01')
      expect(result[:placeholder][:text]).to eq('Pick date')
      expect(result[:initial_date]).to eq('2026-01-01')
    end
  end
end
