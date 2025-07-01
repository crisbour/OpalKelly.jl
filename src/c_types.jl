
# WARN: Why does the LSP warn me about missing reference of enum identifier
@cenum BoardModel::Cuint begin
  ok_brdUnknown          = 0
  ok_brdXEM3001v1        = 1
  ok_brdXEM3001v2        = 2
  ok_brdXEM3010          = 3
  ok_brdXEM3005          = 4
  ok_brdXEM3001CL        = 5
  ok_brdXEM3020          = 6
  ok_brdXEM3050          = 7
  ok_brdXEM9002          = 8
  ok_brdXEM3001RB        = 9
  ok_brdXEM5010          = 10
  ok_brdXEM6110LX45      = 11
  ok_brdXEM6110LX150     = 15
  ok_brdXEM6001          = 12
  ok_brdXEM6010LX45      = 13
  ok_brdXEM6010LX150     = 14
  ok_brdXEM6006LX9       = 16
  ok_brdXEM6006LX16      = 17
  ok_brdXEM6006LX25      = 18
  ok_brdXEM5010LX110     = 19
  ok_brdZEM4310          = 20
  ok_brdXEM6310LX45      = 21
  ok_brdXEM6310LX150     = 22
  ok_brdXEM6110v2LX45    = 23
  ok_brdXEM6110v2LX150   = 24
  ok_brdXEM6002LX9       = 25
  ok_brdXEM6310MTLX45T   = 26
  ok_brdXEM6320LX130T    = 27
  ok_brdXEM7350K70T      = 28
  ok_brdXEM7350K160T     = 29
  ok_brdXEM7350K410T     = 30
  ok_brdXEM6310MTLX150T  = 31
  ok_brdZEM5305A2        = 32
  ok_brdZEM5305A7        = 33
  ok_brdXEM7001A15       = 34
  ok_brdXEM7001A35       = 35
  ok_brdXEM7360K160T     = 36
  ok_brdXEM7360K410T     = 37
  ok_brdZEM5310A4        = 38
  ok_brdZEM5310A7        = 39
  ok_brdZEM5370A5        = 40
  ok_brdXEM7010A50       = 41
  ok_brdXEM7010A200      = 42
  ok_brdXEM7310A75       = 43
  ok_brdXEM7310A200      = 44
  ok_brdXEM7320A75T      = 45
  ok_brdXEM7320A200T     = 46
  ok_brdXEM7305          = 47
  ok_brdFPX1301          = 48
  ok_brdXEM8350KU060     = 49
  ok_brdXEM8350KU085     = 50
  ok_brdXEM8350KU115     = 51
  ok_brdXEM8350SECONDARY = 52
  ok_brdXEM7310MTA75     = 53
  ok_brdXEM7310MTA200    = 54
end

@cenum ErrorCode::Cint begin
  ok_NoError              = 0
  ok_Failed               = -1
  ok_Timeout              = -2
  ok_DoneNotHigh          = -3
  ok_TransferError        = -4
  ok_CommunicationError   = -5
  ok_InvalidBitstream     = -6
  ok_FileError            = -7
  ok_DeviceNotOpen        = -8
  ok_InvalidEndpoint      = -9
  ok_InvalidBlockSize     = -10
  ok_I2CRestrictedAddress = -11
  ok_I2CBitError          = -12
  ok_I2CNack              = -13
  ok_I2CUnknownStatus     = -14
  ok_UnsupportedFeature   = -15
  ok_FIFOUnderflow        = -16
  ok_FIFOOverflow         = -17
  ok_DataAlignmentError   = -18
  ok_InvalidResetProfile  = -19
  ok_InvalidParameter     = -20
end

const ResultLength = Union{Int, ErrorCode}

to_result_length(raw_len::Integer) = if raw_len < 0 ErrorCode(raw_len) else Int(raw_len) end
is_error(err_len::ResultLength) = err_len isa ErrorCode && err_len != ok_NoError
is_error(err::ErrorCode) = err != ok_NoError

struct okTRegisterEntry
	address::UInt32
	data::UInt32
end

struct okTTriggerEntry
	address::UInt32
	mask::UInt32
end


struct okTFPGAResetProfile
	# Magic number indicating the profile is valid.  (4 byte = 0xBE097C3D)
	magic::UInt32

	# Location of the configuration file (Flash boot).  (4 bytes)
	configFileLocation::UInt32

	# Length of the configuration file.  (4 bytes)
	configFileLength::UInt32

	# Number of microseconds to wait after DONE goes high before
	# starting the reset profile.  (4 bytes)
	doneWaitUS::UInt32

	# Number of microseconds to wait after wires are updated
	# before deasserting logic RESET.  (4 bytes)
	resetWaitUS::UInt32

	# Number of microseconds to wait after RESET is deasserted
	# before loading registers.  (4 bytes)
	registerWaitUS::UInt32

	# Future expansion  (112 bytes)
  padBytes1::NTuple{28,UInt32}

	# Initial values of WireIns.  These are loaded prior to
	# deasserting logic RESET.  (32*4 = 128 bytes)
  wireInValues::NTuple{32,UInt32}

	# Number of valid Register Entries (4 bytes)
	registerEntryCount::UInt32

	# Initial register loads.  (256*8 = 2048 bytes)
  registerEntries::NTuple{256, okTRegisterEntry}

	# Number of valid Trigger Entries (4 bytes)
	triggerEntryCount::UInt32

	# Initial trigger assertions.  These are performed last.
	# (32*8 = 256 bytes)
  triggerEntries::NTuple{32, okTTriggerEntry}

	# Padding to a 4096-byte size for future expansion
  padBytes2::NTuple{1520, UInt8}
end

