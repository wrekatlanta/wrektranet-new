# NOT AN ACTIVERECORD MODEL
# A module that produces a hash for a week's show schedule.
module Legacy::Schedule
  SLOT_LENGTH = 10.minutes

  def self.generate_for_day(time = Time.zone.now, opts = {})
    day = time.beginning_of_day
    channel = opts[:channel] || 'main'

    # query 'days' column by the first two letters, lowercase
    wday = Date::DAYNAMES[day.wday][0..1].downcase
    conditions = {
      channel: channel,
      days: wday
    }

    show_schedules = Legacy::ShowSchedule.where(
      'channel = ? AND days = ? AND start_date <= ? AND end_date >= ?',
      channel, wday, day, day
    ).includes(:show)

    schedule_bins = {
      block: {},
      specialty: {},
      oto: {}
    }

    show_schedules.each do |schedule|
      if schedule.show.nil?
        continue
      end

      show = schedule.show

      start_time = schedule.start_time.to_time_of_day
      end_time = schedule.end_time.to_time_of_day

      current_time = start_time

      while current_time < end_time
        schedule_bins[show.show_type.to_sym][current_time.to_s] = show

        current_time += SLOT_LENGTH
      end
    end

    result = {}

    result.merge! schedule_bins[:block]
    result.merge! schedule_bins[:specialty]
    result.merge! schedule_bins[:oto]

    result = result.sort.map do |slot|
      {
        start_time: TimeOfDay.parse(slot[0]).on(day),
        show: slot[1],
        now_playing: false
      }
    end

    # add a current_show indicator by finding the current slot
    # and applying it to adjacent, previous instances of the show
    result.each_with_index do |slot, i|
      current_min = time.min - (time.min % Legacy::Schedule::SLOT_LENGTH)
      time_to_match = time.change(min: current_min)

      if slot[:start_time] == time_to_match
        slot[:now_playing] = true

        j = i - 1

        while (j >= 0)
          if result[j][:show] == slot[:show]
            result[j][:now_playing] = true
          else
            break
          end

          j -= 1
        end

        break
      end
    end

    result
  end
end