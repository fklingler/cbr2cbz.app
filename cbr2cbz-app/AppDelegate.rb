require 'rubygems'
require 'cbr2cbz/converter'

class AppDelegate
  attr_accessor :window
  
  def applicationDidFinishLaunching(a_notification)
    @window.releasedWhenClosed = false
    
    converter = Cbr2cbz::Converter.new
    @cbr2cbz_converter = converter
    @window.instance_eval { @cbr2cbz_converter = converter }
    
    @window.extend DragMethods

    @window.registerForDraggedTypes NSArray.arrayWithObject(NSFilenamesPboardType)
  end
  
  module DragMethods
    def draggingEntered(sender)
      NSDragOperationEvery
    end
    
    def performDragOperation(sender)
      pboard = sender.draggingPasteboard
      files = pboard.propertyListForType NSFilenamesPboardType
      
      @cbr2cbz_converter.convert files
    end
  end

  def menu_convert(sender)
    panel = NSOpenPanel.openPanel
    panel.allowsMultipleSelection = true
    panel.canChooseDirectories = true
    
    panel.beginWithCompletionHandler ->(result) do
      if result == NSFileHandlingPanelOKButton
        @cbr2cbz_converter.convert panel.URLs.map(&:path)
      end
    end
  end

  def application(sender, openFiles:files)
    @cbr2cbz_converter.convert files
  end

  def applicationShouldHandleReopen(application, hasVisibleWindows: hasVisibleWindows)
    @window.makeKeyAndOrderFront(nil)
  end
end

# Monkey patch to search for unrar in different paths 
module Cbr2cbz
  class Converter
    PATH = ["/usr/local/bin", "/usr/bin", "/bin", "/opt/local/bin"]
    
    alias :old_initialize :initialize
    def initialize(options = {})
      old_initialize(options)
      @unrar = PATH.find do |path|
        File.exists? "#{path}/unrar"
      end << "/unrar"
    end
    
    def unrar(filename, folder)
      `#{@unrar} e "#{filename}" "#{folder}/"`
    end
  end
end