require 'slack-ruby-client'
require 'pp'
require './Current.rb'
require './Field.rb'

$command = 'n'
bot = {
      channel: "general",
      name: "bot"
}

Slack.configure do |conf|
      conf.token = "" # slack token
end
client = Slack::RealTime::Client.new

client.on :hello do
      puts 'connected!'
      puts "name: #{bot[:name]}-channel: #{bot[:channel]}"
      client.web_client.chat_postMessage channel: bot[:channel], text: "Hi! If you want to play tetris, you write 'start'."
end

# message eventを受け取った時の処理
client.on :message do |data|
      channel = data['channel']
      if data['text'] == 'start'
            puts "start"
            Thread::start do
                  buttons = {
                        down: "point_down",
                        right: "point_right",
                        left:  "point_left",
                        rotate:  "arrows_counterclockwise"
                  }
                  field = Field.new()
                  current = Current.new(5, 0)

                  posts = client.web_client.chat_postMessage channel: channel, text: to_slack_field(field)
                  buttons.each do |_, value|
                        client.web_client.reactions_add channel: channel,  name: value, timestamp: posts['ts']
                  end
                  sleep(1)
                  loop do
                        sleep(0.5)
                        case $command
                        when buttons[:down]
                              puts "down"
                              tmp = fall_to_block(current, field)
                              init_command()
                        when buttons[:right]
                              puts "right"
                              tmp = current.right.fall
                              init_command()
                        when buttons[:left]
                              puts "left"
                              tmp = current.left.fall
                              init_command()
                        when buttons[:rotate]
                              puts "rotate"
                              tmp = current.rotation.fall
                              init_command()
                        when
                              tmp = current.fall
                        end
                        next_pos = tmp.move_position
                        if !field.are_block?(next_pos)
                              field.pre_fix(next_pos)
                              current = tmp
                        elsif $command != 'n'
                              current = current
                        else
                              field.fix(current.move_position)
                              current = Current.new(5, 0)
                              if field.are_block?(current.move_position)
                                    client.web_client.chat_postMessage channel: channel, text: "game over"
                                    client.stop!
                              end
                        end
                        client.web_client.chat_update channel: channel, text: to_slack_field(field), ts: posts['ts']

                        field.clear
                        field.line_clear
                        if field.game_finish?()
                              client.web_client.chat_postMessage channel: channel, text: "success"
                              client.stop!
                        end
                  end
            end
      end
end

#reactionされた時 入力に使える
client.on :reaction_added do |data|
      $command = data['reaction']
end

#reaction外された時 入力に使える
client.on :reaction_removed do |data|
      $command = data['reaction']
end

def init_command()
      $command = "n"
end

def to_slack_field(field)
      status_to_icon = [ ":white_large_square:", ":black_large_square:", ":o2:", ":o2:" ]
      text = ""
      field.field.each_with_index do |line, y|
            line.each_with_index do |l, x|
                  text += status_to_icon[l]
            end
            text += "\n"
      end
      text += "#{field.point} \n"
      text
end

def fall_to_block(current, field)
      result = current
      loop do
            next_pos = result.fall.move_position
            if field.are_block?(next_pos)
                  return result
            else
                  result = result.fall
            end
      end
end




client.start!
