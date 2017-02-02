#! /usr/bin/env ruby
require 'pry'

class XWindow
  attr_accessor :addr, :desktop, :x, :y, :width, :height, :host, :name

  def initialize(addr, desktop, x, y, width, height, host, *name)
    self.addr = addr
    self.desktop = desktop
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    @host = host
    @name = name
  end

  def addr=(addr)
    @addr = addr.is_a?(String) ? addr.to_i(16) : addr
  end

  def addr_hex
    '0x' + @addr.to_s(16)
  end

  def desktop=(desktop)
    @desktop = desktop.to_i
  end

  def x=(x)
    @x = x.to_i
  end

  def y=(y)
    @y = y.to_i
  end

  def width=(width)
    @width = width.to_i
  end

  def height=(height)
    @height = height.to_i
  end
end

current_desktop = %x(wmctrl -d | grep '*').split.first.strip.to_i

windows_on_desktop = %x(wmctrl -lG).split("\n").map(&:split)
  .map { |args| XWindow.new(*args) }
  .select { |xwindow| xwindow.desktop == current_desktop }

current_window_addr =
  %x(xprop -root | grep '_NET_ACTIVE_WINDOW' | head -1).split.last.to_i(16)
current_window = windows_on_desktop.find { |xw| xw.addr == current_window_addr }

other_windows = windows_on_desktop.reject { |w| w == current_window }

up = other_windows.select { |w| w.y <= current_window.y }.first
dn = other_windows.select { |w| w.y >= current_window.y }.first
lt = other_windows.select { |w| w.x <= current_window.x }.first
rt = other_windows.select { |w| w.x >= current_window.x }.first

switch_to =
  case ARGV.first
  when 'u'
    up.addr_hex if up
  when 'd'
    dn.addr_hex if dn
  when 'l'
    lt.addr_hex if lt
  when 'r'
    rt.addr_hex if rt
  end

%x(wmctrl -i -a #{switch_to}) if switch_to
