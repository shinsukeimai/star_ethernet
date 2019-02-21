module StarEthernet
  module Command
    def self.status_acquisition
      ([0x32] + 50.times.map { 0x00 }).pack('C*')
    end

    def self.initialize_print_sequence
      [
        self.quit_raster_mode,
        self.send_print_end_counter_initialize(0x04, 0x00,0x00),
      ].join
    end

    def self.start_document
      self.send_print_end_counter_initialize(0x03, 0x00, 0x00)
    end

    def self.end_document
      self.send_print_end_counter_initialize(0x04, 0x00, 0x00)
    end


    # Standard Command
    ## Font style and Character Set
    def self.select_font(n)
      [0x1b, 0x1e, 0x46, n].pack('C*')
    end

    def self.select_code_page(t, n)
      [0x1b, 0x1d, t, n].pack('C*')
    end

    def self.write_blank_code_page_data(n1, n2, d)
      [0x1b, 0x1d, 0x3d, n1, n2, *d].pack('C*')
    end

    def self.specify_international_character_set(n)
      [0x1b, 0x52, n].pack('C*')
    end

    def self.specify_cancel_slash_zero(n)
      [0x1b, 0x2f, n].pack('C*')
    end

    def self.set_ank_right_space(n)
      [0x1b, 0x20, n].pack('C*')
    end

    def self.specify_12_dot_pitch
      [0x1b, 0x4d].pack('C*')
    end

    def self.specify_15_dot_pitch
      [0x1b, 0x50].pack('C*')
    end

    def self.specify_16_dot_pitch
      [0x1b, 0x3a].pack('C*')
    end

    def self.specify_14_dot_pitch
      [0x1b, 0x67].pack('C*')
    end


    ## Character Expansion Settings
    def self.set_cancel_the_double_wide_high(n1, n2)
      [0x1b, 0x69, n1, n2].pack('C*')
    end

    def self.specify_cancel_expanded_wide(n)
      [0x1b, 0x57, n].pack('C*')
    end

    def self.specify_cancel_expanded_high(n)
      [0x1b, 0x68, n].pack('C*')
    end

    def self.set_double_wide
      [0x0e].pack('C*')
    end

    def self.cancel_expanded_wide
      [0x14].pack('C*')
    end

    def self.set_double_high
      [0x1b, 0x0e].pack('C*')
    end

    def self.cancel_expanded_high
      [0x1b, 0x14].pack('C*')
    end


    ## Print Mode
    def self.select_emphasized_printing
      [0x1b, 0x45].pack('C*')
    end

    def self.cancel_emphasized_printing
      [0x1b, 0x46].pack('C*')
    end

    def self.select_cancel_underling_mode(n)
      [0x1b, 0x2d, n].pack('C*')
    end

    def self.specify_cancel_upperline(n)
      [0x1b, 0x5f, n].pack('C*')
    end

    def self.select_white_black_inverted_printing
      [0x1b, 0x34].pack('C*')
    end

    def self.cancel_white_black_inversion
      [0x1b, 0x35].pack('C*')
    end

    def self.select_upside_down_printing
      [0x1f].pack('C*')
    end

    def self.cancel_upside_down_printing
      [0x12].pack('C*')
    end

    def self.specify_cancel_smoothing(n)
      [0x1b, 0x1d, 0x62, n].pack('C*')
    end


    ## Line Spacing
    def self.line_feed
      [0x1a].pack('C*')
    end

    def self.carriage_return
      [0x0d].pack('C*')
    end

    def self.feed_paper_in_lines(n)
      [0x1b, 0x61, n].pack('C*')
    end

    def self.select_line_feed_amount(n)
      [0x1b, 0x7a, n].pack('C*')
    end

    def self.specify_line_spacing_to_3_mm
      [0x1b, 0x30].pack('C*')
    end

    def self.n_4_mm_line_feed(n)
      [0x1b, 0x4a, n].pack('C*')
    end

    def self.n_8_mm_line_feed(n)
      [0x1b, 0x49, n].pack('C*')
    end


    ## Page Control Commands
    def self.form_feed
      [0x0c].pack('C*')
    end

    def self.set_page_length_to_n_lines(n)
      [0x1b, 0x43, n].pack('C*')
    end

    def self.set_page_length_to_n_x_24_mm_units(n)
      [0x1b, 0x43, 0x00, n].pack('C*')
    end

    def self.feed_paper_to_vertical_tab_position
      [0x0b].pack('C*')
    end

    def self.set_vertical_tab_position(n)
      [0x1b, 0x42, *n, 0x00].pack('C*')
    end

    def self.clear_vertical_tab_position
      [0x1b, 0x42, 0x00].pack('C*')
    end


    ## Horizontal Direction Printing Position
    def self.set_left_margin(n)
      [0x1b, 0x6c, n].pack('C*')
    end

    def self.set_right_margin(n)
      [0x1b, 0x51, n].pack('C*')
    end

    def self.move_horizontal_tab
      [0x09].pack('C*')
    end

    def self.set_horizontal_tab(n)
      [0x1b, 0x44, *n, 0x00].pack('C*')
    end

    def self.clear_horizontal_tab
      [0x1b, 0x44, 0x00].pack('C*')
    end

    def self.move_absolute_position(n1, n2)
      [0x1b, 0x1d, 0x41, n1, n2].pack('C*')
    end

    def self.move_relative_position(n1, n2)
      [0x1b, 0x1d, 0x52, n1, n2].pack('C*')
    end

    def self.specify_position_alignment(n)
      [0x1b, 0x1d, 0x61, n].pack('C*')
    end


    ## Download
    def self.register_12_x_24_dot_font_download_characters(c1, c2, n, d)
      [0x1b, 0x26, c1, c2, n, *d].pack('C*')
    end

    def self.delete_12_x_24_dot_font_download_characters(c1, c2, n)
      [0x1b, 0x26, c1, c2, n].pack('C*')
    end

    def self.specifies_cancels_ank_download_characters(n)
      [0x1b, 0x25, n].pack('C*')
    end


    ## Bit Image Graphics
    def self.standard_density_bit_image_K(n1, n2, d)
      [0x1b, 0x4b, n1, n2, *d].pack('C*')
    end

    def self.standard_density_bit_image_L(n1, n2, d)
      [0x1b, 0x4c, n1, n2, *d].pack('C*')
    end

    def self.fine_density_bit_image(n1, n2, d)
      [0x1b, 0x6b, n1, n2, *d].pack('C*')
    end

    def self.fine_density_bit_iamge_compatible_with_24_bit_wire_dots(n1, n2, d)
      [0x1b, 0x58, n1, n2, *d].pack('C*')
    end


    ## Logo
    def self.register_logo(n, d)
      [0x1b, 0x1c, 0x71, n, *d].pack('C*')
    end

    def self.print_logo(n, m)
      [0x1b, 0x1c, 0x70, n, m].pack('C*')
    end

    def self.print_logo_in_batch_and_batch_control_of_registered_logos(m0)
      [0x1b, 0x1e, 0x4c, m].pack('C*')
    end


    ## Bar Code
    def self.bar_code(n1, n2, n3, n4, d)
      [0x1b, 0x62, n1, n2, n3, n4, *d, 0x1e].pack('C*')
    end


    ## Cutter Control
    def self.auto_cutter(n)
      [0x1b, 0x64, n].pack('C*')
    end


    ## External Device Drive
    def self.set_external_drive_device_1_pulse_with(n1, n2)
      [0x1b, 0x07, n1, n2].pack('C*')
    end

    def self.external_device_1_drive_instruction_bel
      [0x07].pack('C*')
    end

    def self.external_device_1_drive_instruction_fs
      [0x1c].pack('C*')
    end

    def self.external_device_2_drive_instruction_sub
      [0x1a].pack('C*')
    end

    def self.external_device_2_drive_instruction_em
      [0x19].pack('C*')
    end

    def self.ring_buzzer(m, t1, t2)
      [0x1b, 0x1d, 0x07, m, t1, t2].pack('C*')
    end

    def self.external_buzzer_drive_condition_settings(m, n1, n2)
      [0x1b, 0x1d, 0x19, 0x11, m, n1, n2].pack('C*')
    end

    def self.external_buzzer_drive_execution(m, n1, n2)
      [0x1b, 0x1d, 0x19, 0x12, m, n1, n2].pack('C*')
    end


    ## Print Setting
    def self.set_print_density(n)
      [0x1b, 0x1e, 0x64, n].pack('C*')
    end

    def self.set_print_speed(n)
      [0x1b, 0x1e, 0x72, n].pack('C*')
    end


    ## Status
    def self.set_status_transmission_conditions(n)
      [0x1b, 0x1e, 0x61, n].pack('C*')
    end

    def self.real_time_printer_status
      [0x1b, 0x06, 0x01].pack('C*')
    end

    def self.real_time_printer_status_1
      [0x05].pack('C*')
    end

    def self.real_time_printer_status_2
      [0x04].pack('C*')
    end

    def self.execute_real_time_printer_reset
      [0x1b, 0x06, 0x18].pack('C*')
    end

    def self.update_asb_etb_status
      [0x17].pack('C*')
    end

    def self.initialize_asb_etb_counter_and_etb_status(n)
      [0x1b, 0x1e, 0x45, n].pack('C*')
    end

    def self.send_print_end_counter_initialize(s, n1, n2)
      [0x1b, 0x1d, 0x03, s, n1, n2].pack('C*')
    end


    ## Kanji characters
    def self.specify_jis_character_mode
      [0x1b, 0x70].pack('C*')
    end

    def self.cancel_jis_kanji_character_mode
      [0x1b, 0x71].pack('C*')
    end

    def self.specify_cancel_shift_jis_kanji_character_mode(n)
      [0x1b, 0x24, n].pack('C*')
    end

    def self.set_2_byte_kanji_character_left_right_spaces(n1, n2)
      [0x1b, 0x73, 0x73, n1, n2].pack('C*')
    end

    def self.set_1_byte_kanji_character_left_right_spaces(n1, n2)
      [0x1b, 0x74, n1 ,n2].pack('C*')
    end

    def self.register_chinese_download_characters(c1, c2, d)
      [0x1b, 0x72, c1, c2, *d].pack('C*')
    end


    ## Others
    def self.cancel_print_data_and_initialize_commands
      [0x18].pack('C*')
    end

    def self.command_initialization
      [0x1b, 0x40].pack('C*')
    end

    def self.set_memory_switch(m, n, n1, n2, n3, n4)
      [0x1b, 0x1d, 0x23, m, n ,n1, n2 ,n3, n4, 0x0a, 0x00].pack('C*')
    end

    def self.reset_printer_execute_self_print
      [0x1b, 0x3f, 0x0a, 0x00].pack('C*')
    end

    def self.initialize_raster_mode
      [0x1b, 0x2a, 0x72, 0x52].pack('C*')
    end

    def self.enter_raster_mode
      [0x1b, 0x2a, 0x72, 0x41].pack('C*')
    end

    def self.quit_raster_mode
      [0x1b, 0x2a, 0x72, 0x42].pack('C*')
    end

    def self.clear_raster_data
      [0x1b, 0x2a, 0x72, 0x43].pack('C*')
    end

    def self.drawer_drive(n)
      [0x1b, 0x2a, 0x72, 0x44, n, 0x00].pack('C*')
    end

    def self.set_raster_eot_mode
      [0x1b, 0x2a, 0x72, 0x45, n, 0x00].pack('C*')
    end

    def self.set_raster_ff_mode
      [0x1b, 0x2a, 0x72, 0x46, n, 0x00].pack('C*')
    end

    def self.set_raster_page_length(n)
      [0x1b, 0x2a, 0x72, 0x50, n, 0x00].pack('C*')
    end

    def self.set_raster_print_quality
      [0x1b, 0x2a, 0x72, 0x51, n, 0x00].pack('C*')
    end

    def self.set_raster_left_margin(n)
      [0x1b, 0x2a, 0x72, 0x6d, 0x6c, n, 0x00].pack('C*')
    end

    def self.set_raster_right_margin(n)
      [0x1b, 0x2a, 0x72, 0x6d, 0x72, n, 0x00].pack('C*')
    end

    def self.set_raster_to_margin(n)
      [0x1b, 0x2a, 0x72, 0x54, n, 0x00].pack('C*')
    end

    def self.set_raster_print_color(n)
      [0x1b, 0x2a, 0x72, 0x4b, n, 0x00].pack('C*')
    end

    def self.send_raster_data_auto_line_feed(n1, n2, d)
      [0x62, n1, n2, *d].pack('C*')
    end

    def self.transfer_raster_data(n1, n2, d)
      [0x5b, n1, n2, *d].pack('C*')
    end

    def self.move_vertical_direction_position_line_feed_for_specified_dots(n)
      [0x1b, 0x2a, 0x72, 0x59, n, 0x00].pack('C*')
    end

    def self.execute_ff_mode
      [0x1b, 0x0c, 0x00].pack('C*')
    end

    def self.execute_eot_mode
      [0x1b, 0x0c, 0x04].pack('C*')
    end

    def self.execute_external_buzzer_drive(m, n)
      [0x1b, 0x2a, 0x72, 0x56, m ,n ,0x00].pack('C*')
    end

    def self.raster_mode_audio_playback
      [0x1b, 0x2a, 0x72, 0x53].pack('C*')
    end

    def self.set_raster_mode_nv_audio_playback_number(a, n)
      [0x1b, 0x2a, 0x72, 0x73, 0x30, a, n, 0x00].pack('C*')
    end

    def self.set_raster_mode_nv_audio_playback_count(n)
      [0x1b, 0x2a, 0x72, 0x73, 0x31, n, 0x00].pack('C*')
    end

    def self.set_raster_mode_nv_audio_playback_interval_time(n)
      [0x1b, 0x2a, 0x72, 0x73, 0x33, n, 0x00].pack('C*')
    end


    ## Black Mark Related Command Details
    def self.execute_top_form
      [0x0c].pack('C*')
    end

    def self.set_page_length_to_lines(n)
      [0x1b, 0x43, n].pack('C*')
    end

    def self.feed_paper_to_vertical_table_position
      [0x0b].pack('C*')
    end


    ## 2 Color Printing Command Detail
    def self.set_print_color_in_2_color_print_mode(n)
      [0x1b, 0x1e, 0x63, n].pack('C*')
    end

    def self.select_cancel_2_color_print_mode(n)
      [0x1b, 0x1e, 0x43, n].pack('C*')
    end


    ## Presenter Related Command Details
    def self.execute_presenter_paper_recovery(n)
      [0x1b, 0x16, 0x30, n].pack('C*')
    end

    def self.set_presenter_paper_automatic_recover_function_and_automatic_recovery_time(n)
      [0x1b, 0x16, 0x31, n].pack('C*')
    end

    def self.set_presenter_operation_mode(n)
      [0x1b, 0x16, 0x32, n].pack('C*')
    end

    def self.acquire_presenter_paper_counter(n)
      [0x1b, 0x16, 0x33, n].pack('C*')
    end

    def self.initialize_presenter_paper_counter(n)
      [0x1b, 0x16, 0x34, n].pack('C*')
    end

    def self.specify_snout_operation_mode(m, t1, t2)
      [0x1b, 0x1d, 0x1a, 0x11, m, t1, t2].pack('C*')
    end

    def self.specify_snout_led_no_off(m, t1, t2)
      [0x1b, 0x1d, 0x1a, 0x12, m ,t1, t2].pack('C*')
    end

    def self.snout_led_output(m, t1, t2)
      [0x1b, 0x1d, 0x1a, 0x13, m, t1, t2].pack('C*')
    end


    ## Mark Command Details
    def self.print_mark(n, m)
      [0x1b, 0x1d, 0x2a, 0x30, n, *m].pack('C*')
    end

    def self.specify_mark_height_and_line_feed(h, v)
      [0x1b, 0x1d, 0x2a, 0x31, h, v].pack('C*')
    end

    def self.specify_mark_color_and_mark_horizontal_width_for_each_number(m, c, w)
      [0x1b, 0x1d, 0x2a, 0x32, m, c, w].pack('C*')
    end

    def self.register_mark_format_to_non_volatile_memory
      [0x1b, 0x1d, 0x2a, 0x57].pack('C*')
    end

    def self.initialize_mark_format_in_the_non_volatile_memory
      [0x1b, 0x1d, 0x2a, 0x43].pack('C*')
    end


    ## AUTO LOGO Function Command Details
    def self.register_auto_logo_setting_to_non_volatile_memory
      [0x1b, 0x1d, 0x2f, 0x57].pack('C*')
    end

    def self.initialize_auto_logo_setting_to_non_volatile_memory
      [0x1b, 0x1d, 0x2f, 0x43].pack('C*')
    end

    def self.auto_logo_function_on_off_setting(n)
      [0x1b, 0x1d, 0x2f, 0x31, n].pack('C*')
    end

    def self.set_command_character(n)
      [0x1b, 0x1d, 0x2f, 0x32, n].pack('C*')
    end

    def self.set_user_macro_1(nL, nH, d)
      [0x1b, 0x1d, 0x2f, 0x33, nL, nH, *d].pack('C*')
    end

    def self.set_command_character_switch_method(n)
      [0x1b, 0x1d, 0x2f, 0x35, n].pack('C*')
    end

    def self.set_partial_cut_before_logo_printing(n)
      [0x1b, 0x1d, 0x2f, 0x36, n].pack('C*')
    end


    ## Two-dimensional Bar Code PDF417 Command Details
    def self.set_pdf_417_bar_code_size(n, p1, p2)
      [0x1b, 0x1d, 0x78, 0x53, 0x30, n, p1, p2].pack('C*')
    end

    def self.set_pdf_417_ecc_security_lebel(n)
      [0x1b, 0x1d, 0x78, 0x53, 0x31, n].pack('C*')
    end

    def self.set_pdf_417_module_x_direction_size(n)
      [0x1b, 0x1d, 0x78, 0x53, 0x32, n].pack('C*')
    end

    def self.set_pdf_417_module_aspect_ratio(n)
      [0x1b, 0x1d, 0x78, 0x53, 0x33, n].pack('C*')
    end

    def self.set_pdf_417_bar_code_data(nL, nH, d)
      [0x1b, 0x1d, 0x78, 0x44,nL, nH, *d].pack('C*')
    end

    def self.print_pdf_417_bar_code
      [0x1b, 0x1d, 0x78, 0x50].pack('C*')
    end

    def self.get_pdf_417_bar_code_expansion_information
      [0x1b, 0x1d, 0x78, 0x49].pack('C*')
    end


    ## Details of Print Starting Trigger Control Command
    def self.print_starting_trigger(m, n)
      [0x1b, 0x1d, 0x67, 0x30, m, n].pack('C*')
    end

    def self.print_starting_timer(m, n)
      [0x1b, 0x1d, 0x67, 0x31, m, n].pack('C*')
    end


    ## Two-Dimensional Bar Code QR Code Command Details
    def self.set_qr_code_model(n)
      [0x1b, 0x1d, 0x79, 0x53, 0x30, n].pack('C*')
    end

    def self.set_qr_code_mistake_correction_level(n)
      [0x1b, 0x1d, 0x79, 0x53, 0x31, n].pack('C*')
    end

    def self.set_qr_code_cell_size(n)
      [0x1b, 0x1d, 0x79, 0x53, 0x32, n].pack('C*')
    end

    def self.set_qr_code_data_auto_setting(m, nL, nH, d)
      [0x1b, 0x1d, 0x79, 0x44, 0x31, m, nL, nH, *d].pack('C*')
    end

    def self.set_qr_code_data_manual_setting(a, m1, n1L, n1H, d)
      [0x1b, 0x1d, 0x79, 0x44, 0x32, a, m1, n1L, n1H, *d].pack('C*')
    end

    def self.print_qr_code
      [0x1b, 0x1d, 0x79, 0x50].pack('C*')
    end

    def self.get_qr_code_expansion_information
      [0x1b, 0x1d, 0x79, 0x49].pack('C*')
    end


    ## GS1 2D Code, Compound symbol Command Details
    def self.set_and_print_symbol(pL, pH, cn, fn, n)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, n].pack('C*')
    end

    def self._2d_gs1_databar_set_module_siz(pL, pH, cn ,fn, n)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn ,fn, n].pack('C*')
    end

    def self._2d_gs1_databar_set_the_maximum_width_of_the_2d_gs1_databar_expanded_stacked(pL, pH, cn ,fn, nL, nH)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn ,fn, nL, nH].pack('C*')
    end

    def self._2d_gs1_databar_store_data_in_symbol_saving_region(pL, pH, cn, fn, m, n, d)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, m, n, *d].pack('C*')
    end

    def self._2d_gs1_databar_print_symbol_data_fo_symbol_saving_region(pL, pH, cn, fn, m)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, m].pack('C*')
    end

    def self.compound_symbol_set_module_width(pL, pH, cn, fn, n)
      [0x1b, 0x1d, 0x28, 0x6, pL, pH, cn, fn, n].pack('C*')
    end

    def self.compound_symbol_set_the_maximum_width_of_the_2d_gs1_databar_expanded_stacked(pL, pH, cn, nL, nH)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, nL, nH].pack('C*')
    end

    def self.compound_symbol_set_the_hri_font(pL, pH, cn, fn, n)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, n].pack('C*')
    end

    def self.compound_symbol_store_data_in_symbol_saving_region(pL, pH, cn, fn, m, a, b, d)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, m, a, b, d].pack('C*')
    end

    def self.compound_symbol_print_data_in_symbol_saving_region(pL, pH, cn, fn, m)
      [0x1b, 0x1d, 0x28, 0x6b, pL, pH, cn, fn, m].pack('C*')
    end


    ## Page Function Command Details
    def self._180_degree_turnover_1(k, m, n)
      [0x1b, 0x1d, 0x68, 0x30, k, m, n].pack('C*')
    end

    def self._180_degree_turnover_2(k, m, n)
      [0x1b, 0x1d, 0x68, 0x31, k, m, n].pack('C*')
    end


    ## Reduced Printing Function Command Details
    def self.set_reduced_printing(h, v)
      [0x1b, 0x1d, 0x63, h, v].pack('C*')
    end


    ## Page Mode Command Details
    def self.selects_page_mode
      [0x1b, 0x1d, 0x50, 0x30].pack('C*')
    end

    def self.cancel_page_mode
      [0x1b, 0x1d, 0x50, 0x31].pack('C*')
    end

    def self.select_character_print_direction_in_page_mode
      [0x1b, 0x1d, 0x50, 0x32].pack('C*')
    end

    def self.set_print_region_in_page_mode
      [0x1b, 0x1d, 0x50, 0x33].pack('C*')
    end

    def self.specify_character_vertical_direction_absolute_position_in_page_mode
      [0x1b, 0x1d, 0x50, 0x34].pack('C*')
    end

    def self.specify_character_vertical_direction_relative_position_in_page_mode
      [0x1b, 0x1d, 0x50, 0x35].pack('C*')
    end

    def self.print_data_in_page_mode
      [0x1b, 0x1d, 0x50, 0x36].pack('C*')
    end

    def self.print_in_page_mode_and_recover
      [0x1b, 0x1d, 0x50, 0x37].pack('C*')
    end

    def self.cancel_print_data_in_page_mode
      [0x1b, 0x1d, 0x50, 0x38].pack('C*')
    end


    ## Text Search Command Details
    def self.set_text_search(pL, pH, fn, param)
      [0x1b, 0x29, 0x42, pL, pH, fn, param].pack('C*')
    end

    def self.enable_and_disables_text_search(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end

    def self.set_the_number_of_times_to_run_the_text_search_macro(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end

    def self.set_to_print_the_string_the_matches_in_the_text_search(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end

    def self.define_the_text_search_string(pL, pH, fn, n, m, k, d)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, n, m, k, *d].pack('C*')
    end

    def self.define_the_text_search_macro(pL, pH, fn, m, k1, k2, d)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m, k1, k2, *d].pack('C*')
    end

    def self.initialize_text_search_settings_and_definitions(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end

    def self.print_the_text_search_settings_and_definitions(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end

    def self.run_the_text_search_macro(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x42, pL, pH, fn, m].pack('C*')
    end


    ## Audio Command Details
    def self.playback_nv_audio(z, a, n, c1, c2, d1, d2, t1, t2)
      [0x1b, 0x1d, 0x73, 0x4f, z, a, n, c1, c2, d1, d2, t1, t2].pack('C*')
    end

    def self.stop_vn_audio
      [0x1b, 0x1d, 0x73, 0x50].pack('C*')
    end

    def self.playback_receive_audio(z, n1, n2, n3, d)
      [0x1b, 0x1d, 0x73, 0x52, z, n1, n2, n3, *d].pack('C*')
    end

    def self.register_automatic_audio_setting_information(z, e, a, n ,c1, c2, d1, d2, t1, t2)
      [0x1b, 0x1d, 0x73, 0x49, z, e, a, n ,c1, c2, d1, d2, t1, t2].pack('C*')
    end

    def self.register_user_area_nv_audio_data(z, n, d)
      [0x1b, 0x1d, 0x73, 0x55, z, n, *d].pack('C*')
    end

    def self.batch_playback_of_nv_audio(a, t1, t2)
      [0x1b, 0x1d, 0x73, 0x54, a, t1, t2].pack('C*')
    end


    ## Graphics data Command Details
    def self.specify_graphics_data_1(pL, pH, n, fn, params)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, n, fn, *params].pack('C*')
    end

    def self.specify_graphics_data_2(p1, p2, p3, p4, m, fn, params)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn, params].pack('C*')
    end

    def self.send_nv_graphics_memory_capacity_48_1(pL, pH, m, fn)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn].pack('C*')
    end

    def self.send_nv_graphics_memory_capacity_48_2(p1, p2, p3, p4,  m, fn)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn].pack('C*')
    end

    def self.send_nv_graphics_memory_capacity_51_1(pL, pH, m, fn)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn].pack('C*')
    end

    def self.send_nv_graphics_memory_capacity_51_2(p1, p2, p3, p4, m, fn)
      [0x1b, 0x1d, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m ,fn].pack('C*')
    end

    def self.function_64_1(pL, pH, m, fn, d1, d2)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn, d1, d2].pack('C*')
    end

    def self.function_64_2(p1, p2, p3, p4, m, fn, d1, d2)
      [0x1b, 0x1d, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn, d1, d2].pack('C*')
    end

    def self.function_65_1(pL, pH, m ,fn, d1, d2, d3)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m ,fn, d1, d2, d3].pack('C*')
    end

    def self.function_65_2(p1, p2, p3, p4, m, fn, d1, d2, d3)
      [0x1b, 0x1d, 0x28, 0x4c, p1, p2, p3, p4, m, fn, d1, d2, d3].pack('C*')
    end

    def self.erase_the_specified_vn_graphics_data_function_66_1(pL, pH, m, fn ,kc1, kc2)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn ,kc1, kc2].pack('C*')
    end

    def self.erase_the_specified_vn_graphics_data_function_66_2(p1, p2, p3, p4, m, fn, kc1, kc2)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn, kc1, kc2].pack('C*')
    end

    def self.erase_the_specified_nv_graphics_data_function_67_1(pL, pH, m, fn, a, kc1, kc2, b, xL, xH, yL, yH, cd)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn, a, kc1, kc2, b, xL, xH, yL, yH, *cd].pack('C*')
    end

    def self.erase_the_specified_nv_graphics_data_function_67_2(p1, p2, p3, p4, m, fn, a, kc1, kc2, xL, xH, yL, yH, cd)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn, a, kc1, kc2, xL, xH, yL, yH, cd].pack('C*')
    end

    def self.print_the_specified_nv_graphics_data_function_69_1(pL, pH, m, fn, kc1, kc2, x, y)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn, kc1, kc2, x, y].pack('C*')
    end

    def self.print_the_specified_nv_graphics_data_function_69_2(p1, p2, p3, p4, m, fn, kc1, kc2, x, y)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m, fn, kc1, kc2, x, y].pack('C*')
    end

    def self.print_the_specified_nv_graphics_data_function_112_1(pL, pH, m, fn, a, bx, by, c, xL, xH, yL, yH, d)
      [0x1b, 0x1d, 0x28, 0x4c, pL, pH, m, fn, a, bx, by, c, xL, xH, yL, yH, *d].pack('C*')
    end

    def self.print_the_specified_nv_graphics_data_function_112_2(p1, p2, p3, p4, m ,fn, a, bx, by, c, xL, xH, yL, yH, d)
      [0x1b, 0x1d, 0x38, 0x4c, p1, p2, p3, p4, m ,fn, a, bx, by, c, xL, xH, yL, yH, *d].pack('C*')
    end


    ## Individual Logo Commands
    def self.set_graphics_data(pL, pH, fn)
      [0x1b, 0x1b, 0x29, 0x4c, pL, pH, fn].pack('C*')
    end

    def self.send_registered_individual_logo_crc(pL, pH, fn, kc1, kc2)
      [0x1b, 0x1d, 0x29, 0x4c, pL, pH, fn, kc1, kc2].pack('C*')
    end

    def self.transmit_capacity_used_registered_individual_nv_graphics(pL, pH, fn, kc1, kc2)
      [0x1b, 0x1d, 0x29, 0x4c, pL, pH, fn, kc1, kc2].pack('C*')
    end

    def self.send_all_key_code_the_registered_nv_graphics(pL, pH, fn, d1, d2)
      [0x1b, 0x1d, 0x29, 0x4c, pL, pH, fn, d1, d2].pack('C*')
    end


    ## Printer Information Transmission Commands
    def self.transmit_printer_information(pL, pH, fn, params)
      [0x1b, 0x29, 0x49, pL, pH, fn, *params].pack('C*')
    end

    def self.transmit_all_types_of_multibyte_fonts(pL, pH, fn, d1, d2)
      [0x1b, 0x1d, 0x29, 0x49, pL, pH, fn, d1, d2].pack('C*')
    end


    ## UTF Commands
    def self.set_unicode(pL, pH, fn, params)
      [0x1b, 0x29, 0x55, pL, pH, fn, *params].pack('C*')
    end

    def self.set_unicode_analysis(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x55, pL, pH, fn, m].pack('C*')
    end

    def self.setting_of_unicode_ambiguous_character(pL, pH, fn, m)
      [0x1b, 0x1d, 0x29, 0x55, pL, pH, fn, m].pack('C*')
    end

    def self.set_utf_8_cjk_unified_ideograph_font(pL, pH, fn, n1, n2, n3, n4)
      [0x1b, 0x1d, 0x29, 0x55, pL, pH, fn, n1, n2, n3, n4].pack('C*')
    end
  end
end
