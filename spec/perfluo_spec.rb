#!/usr/bin/env ruby
require 'json'
require 'perfluo'
module Perfluo
  RSpec.describe "Memory" do
    let(:bot) { Bot.new }
    let(:event_name) {"somthing"}

    describe "#remember_that?" do
      context "doesn't remember (no occurence)" do
        it "returns null" do
          expect(bot.remember_that?(event_name)).to be_nil
        end
      end

      context "happened some times" do
        it "returns the number of occurences" do
          n = 1 + rand(20)
          n.times{bot.remember_that!(event_name)}
          expect(bot.remember_that?(event_name)).to be_an Integer
          expect(bot.remember_that?(event_name)).to eq n
        end
      end
    end
    describe "#remember_that!" do
      it "increments the ocurrence count" do
        expect{bot.remember_that!(event_name)}.to change{bot.remember_that?(event_name)}.from(nil).to(1)
        expect{bot.remember_that!(event_name)}.to change{bot.remember_that?(event_name)}.from(1).to(2)
      end
    end
  end
end

module Perfluo
  RSpec.describe "Bot" do
    let(:bot) { Bot.new }
    let(:output) {bot.react_to_listen(input);bot.output.content }
    context "simple regex match" do
      let(:input) {'oi'}
      before do
        bot.setup do
          listen /\boi\b/ do
            say "oi"
          end
        end
      end

      it "reacts to what we say when matching" do
        expect(output).to eq "oi"
      end
    end

    context "compound regex match" do
      let(:input) {'boleto'}
      describe "case all" do
        before do
          bot.listen  [/segunda via/, /boleto/], {case: :all} do
            say "vc quer segunda via"
          end
        end
        context "all matchers match" do
          let(:input) { "boleto de segunda via" }
          it { expect(output).to eq "vc quer segunda via" }
        end
        context "not all matches" do
          let(:input) { "conta de segunda via" }
          it { expect(output).to eq nil }
        end
      end

      context "case any" do
        before{ bot.listen  [/2via fatura/, /boleto/] {  say "vc quer segunda via" } }

        it "is self behaviour" do
          expect(output).to eq "vc quer segunda via"
        end
        it "works any when matchers matches", case: :any do
          expect(output).to eq "vc quer segunda via"
        end
      end

      context "multiple matchable listens" do
        let(:input) { "foo" }
        before do
          bot.listen  [/aaa/] {  say "noop" }
          bot.listen  [/fo/] {  say "first trigger" }
          bot.listen  [/bbb/] {  say "noop" }
          bot.listen  [/oo/] {  say "second trigger" }
          bot.listen  [/ccc/] {  say "noop" }
        end

        it "matches the first only" do
          expect(output).to eq "first trigger"
        end
      end
    end

    describe "contextualization" do
      before do
        bot.setup do
          about "yyy" do
            listen "bolo" do
              change_subject "/xxx"
            end
          end

          about "boleto" do
            enter do
              say "Estou aprendendo a emitor boletos"
            end

            listen "bolo" do
              change_subject "/bolo"
            end
          end

          about "bolo" do
            enter do
              say "Eu ainda não sei fazer bolos, mas assim que eu aprender eu te aviso"
            end
          end

          about "xxx" do
            listen "bolo" do
              change_subject "/yyy"
            end
          end

          listen "boleto" do
            change_subject "/boleto"
          end
        end
      end

      it "changes to subject " do
        expect(bot.current_subject_path).to eq "/"
        expect(bot.listen_triggers.count).to eq 1
        expect(bot.subjects_stack).to eq %w{ / }
        expect{ bot.react_to_listen('bolo') }.to_not change(bot,:current_subject_path).from('/')
        expect(bot.subjects_stack).to eq %w{ / }
        expect(bot.subjects_stack).to eq %w{ /  }
        expect{bot.react_to_listen('boleto')}.to change(bot,:current_subject_path).to('/boleto')
        expect(bot.subjects_stack).to eq %w{ / /boleto }
        expect{bot.react_to_listen('bolo')}.to change(bot,:current_subject_path).to('/bolo')
        expect(bot.subjects_stack).to eq %w{ / /boleto /bolo }
      end
    end

    describe "#save!" do
      it { expect{bot.save!}.to_not raise_error}
    end
  end
end
