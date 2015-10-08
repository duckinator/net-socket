require 'spec_helper'

describe Net::Socket do
  it 'has a version number' do
    expect(Net::Socket::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
