# qube-ruby

Сlient for the Tarantool [Queue](https://github.com/tarantool/queue) for Ruby over HTTP via persistent connection. Currently supported is `take`, `put`, `ack` and will continue to add as needed.

```ruby
require 'qube'

Qube.setup do |c|
  c.api_uri    = 'http://localhost:5672/api/v1/'
  c.api_token  = '77c04ced3f915240d0c5d8d5819f84c7' # md5 -s qube
end

queue = Qube::Queue.new
pp queue.tube_exist?('welcome_mail') # => false

tube = queue.create_tube(name: 'welcome_mail', type: 'fifo')
pp tube # => #<Qube::Tube:0x00007fe68b159b80 ...

put_status = tube.put({ name: 'Ivan Ivanov', locale: 'ru', email: 'ivan@localhost.dev' })
pp put_status # => true

task = tube.take
pp task
# =>
# {
#  "task_id" => 0,
#     "data" => {
#       "email" => "ivan@localhost.dev",
#        "name" => "Ivan Ivanov",
#      "locale" => "ru"
#  }
# }

ack_status = tube.ack task.dig('task_id')
pp ack_status
# => true

# Taking the each task, processing and ack it in the one step
tube.each_task do |task|
  pp task
end

delete_status = queue.delete_tube('welcome_mail')
pp delete_status
# => true
```