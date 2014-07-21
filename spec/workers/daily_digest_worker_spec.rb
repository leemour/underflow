require 'spec_helper'

describe DailyDigestWorker do
  it "sends daily digest to users" do
    expect(User).to receive(:send_daily_digest)
    subject.perform
  end

  describe "scheduling" do
    it "runs daily" do
      next_day_midnight = Time.zone.now.beginning_of_day + 1.day
      next_day_midday = next_day_midnight + 12.hours
      expect(next_occurrence).to eq(next_day_midnight)
      expect(next_occurrence).to_not eq(next_day_midday)

      allow(Time).to receive(:now).and_return(next_day_midday)
      expect(next_occurrence).to eq(next_day_midnight + 1.day)
    end
  end

  def next_occurrence
    described_class.schedule.next_occurrence
  end
end