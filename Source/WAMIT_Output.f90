!**********************************************************************************************************************************
! LICENSING
! Copyright (C) 2013-2015  National Renewable Energy Laboratory
!
!    This file is part of HydroDyn.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!    
!**********************************************************************************************************************************
! File last committed: $Date: 2016-03-14 13:34:22 -0600 (Mon, 14 Mar 2016) $
! (File) Revision #: $Rev: 663 $
! URL: $HeadURL: https://windsvn.nrel.gov/HydroDyn/branches/WaveStretching/Source/WAMIT_Output.f90 $
!**********************************************************************************************************************************
MODULE WAMIT_Output

      ! This MODULE stores variables used for output.

   USE                              NWTC_Library
   USE                              WAMIT_Types
   !USE                              HydroDyn_Output_Types
   USE                              Waves
   IMPLICIT                         NONE
   
   PRIVATE

       ! Indices for computing output channels:
     ! NOTES: 
     !    (1) These parameters are in the order stored in "OutListParameters.xlsx"
     !    (2) Array AllOuts() must be dimensioned to the value of the largest output parameter

   INTEGER(IntKi), PARAMETER      :: OutStrLenM1 = ChanLen - 1 

  ! WAMIT Body Forces:

   INTEGER(IntKi), PARAMETER      :: WavesF1xi =  1
   INTEGER(IntKi), PARAMETER      :: WavesF1yi =  2
   INTEGER(IntKi), PARAMETER      :: WavesF1zi =  3
   INTEGER(IntKi), PARAMETER      :: WavesM1xi =  4
   INTEGER(IntKi), PARAMETER      :: WavesM1yi =  5
   INTEGER(IntKi), PARAMETER      :: WavesM1zi =  6
   INTEGER(IntKi), PARAMETER      :: HdrStcFxi =  7
   INTEGER(IntKi), PARAMETER      :: HdrStcFyi =  8
   INTEGER(IntKi), PARAMETER      :: HdrStcFzi =  9
   INTEGER(IntKi), PARAMETER      :: HdrStcMxi = 10
   INTEGER(IntKi), PARAMETER      :: HdrStcMyi = 11
   INTEGER(IntKi), PARAMETER      :: HdrStcMzi = 12
   INTEGER(IntKi), PARAMETER      :: RdtnFxi   = 13
   INTEGER(IntKi), PARAMETER      :: RdtnFyi   = 14
   INTEGER(IntKi), PARAMETER      :: RdtnFzi   = 15
   INTEGER(IntKi), PARAMETER      :: RdtnMxi   = 16
   INTEGER(IntKi), PARAMETER      :: RdtnMyi   = 17
   INTEGER(IntKi), PARAMETER      :: RdtnMzi   = 18


  
!End of code generated by Matlab script

   
   INTEGER, PARAMETER             :: FWaves1(6)   = (/WavesF1xi,WavesF1yi,WavesF1zi,WavesM1xi,WavesM1yi,WavesM1zi/)
   INTEGER, PARAMETER             :: FHdrSttc(6)  = (/HdrStcFxi,HdrStcFyi,HdrStcFzi,HdrStcMxi,HdrStcMyi,HdrStcMzi/)
   INTEGER, PARAMETER             :: FRdtn(6)     = (/RdtnFxi,RdtnFyi,RdtnFzi,RdtnMxi,RdtnMyi,RdtnMzi/)
   
  
   
   ! NOTE: The following lines of code were generated by a Matlab script called "Write_ChckOutLst.m"
!      using the parameters listed in the "OutListParameters.xlsx" Excel file. Any changes to these 
!      lines should be modified in the Matlab script and/or Excel worksheet as necessary. 
! This code was generated by Write_ChckOutLst.m at 21-Mar-2013 08:13:04.
   CHARACTER(OutStrLenM1), PARAMETER  :: ValidParamAry(18) =  (/ &                  ! This lists the names of the allowed parameters, which must be sorted alphabetically
                               "HDRSTCFXI","HDRSTCFYI","HDRSTCFZI","HDRSTCMXI","HDRSTCMYI","HDRSTCMZI",   &
                               "RDTNFXI  ","RDTNFYI  ","RDTNFZI  ","RDTNMXI  ","RDTNMYI  ","RDTNMZI  ",   &
                               "WAVESF1XI","WAVESF1YI","WAVESF1ZI","WAVESM1XI","WAVESM1YI","WAVESM1ZI"/)
   INTEGER(IntKi), PARAMETER :: ParamIndxAry(18) =  (/ &                            ! This lists the index into AllOuts(:) of the allowed parameters ValidParamAry(:)
                                HdrStcFxi , HdrStcFyi , HdrStcFzi , HdrStcMxi , HdrStcMyi , HdrStcMzi ,   &
                                  RdtnFxi ,   RdtnFyi ,   RdtnFzi ,   RdtnMxi ,   RdtnMyi ,   RdtnMzi ,   &
                                 WavesF1xi,  WavesF1yi,  WavesF1zi,  WavesM1xi,  WavesM1yi,  WavesM1zi/)
   CHARACTER(ChanLen), PARAMETER :: ParamUnitsAry(18) =  (/ &                     ! This lists the units corresponding to the allowed parameters
                               "(N)       ","(N)       ","(N)       ","(N�m)     ","(N�m)     ","(N�m)     ",  &
                               "(N)       ","(N)       ","(N)       ","(N�m)     ","(N�m)     ","(N�m)     ",  &
                               "(N)       ","(N)       ","(N)       ","(N�m)     ","(N�m)     ","(N�m)     "/)
   

   REAL(ReKi)               :: AllOuts(MaxWAMITOutputs)          ! Array of all possible outputs
   
      ! ..... Public Subroutines ...................................................................................................
   PUBLIC :: WMTOUT_MapOutputs
   PUBLIC :: WMTOUT_WriteOutputNames
   PUBLIC :: WMTOUT_WriteOutputUnits
   PUBLIC :: WMTOUT_WriteOutputs
   PUBLIC :: WMTOUT_Init
   PUBLIC :: WMTOUT_DestroyParam
   PUBLIC :: GetWAMITChannels

CONTAINS




!====================================================================================================
SUBROUTINE WMTOUT_MapOutputs( CurrentTime, y, F_Waves1, F_HS, F_Rdtn, F_PtfmAM, AllOuts, ErrStat, ErrMsg )
! This subroutine writes the data stored in the y variable to the correct indexed postions in WriteOutput
! This is called by WAMIT_CalcOutput() at each time step.
!---------------------------------------------------------------------------------------------------- 
   REAL(DbKi),                         INTENT( IN    )  :: CurrentTime    ! Current simulation time in seconds
   TYPE(WAMIT_OutputType),             INTENT( INOUT )  :: y              ! WAMIT's output data
   REAL(ReKi),                         INTENT( IN    )  :: F_Waves1(6)
   REAL(ReKi),                         INTENT( IN    )  :: F_HS(6)
   REAL(ReKi),                         INTENT( IN    )  :: F_Rdtn(6)
   REAL(ReKi),                         INTENT( IN    )  :: F_PtfmAM(6)
   REAL(ReKi),                         INTENT(   OUT )  :: AllOuts(MaxWAMITOutputs)
   INTEGER(IntKi),                     INTENT(   OUT )  :: ErrStat        ! Error status of the operation
   CHARACTER(*),                       INTENT(   OUT )  :: ErrMsg         ! Error message if ErrStat /= ErrID_None

!   INTEGER                                              :: I
   
   ErrStat = ErrID_None
   ErrMsg = ""
   
   
   ! TODO:  use y%mesh for the forces instead of individual parameters

   !AllOuts(Time)      = REAL(CurrentTime,ReKi)
   AllOuts(FWaves1)  = F_Waves1
   AllOuts(FHdrSttc) = F_HS
   AllOuts(FRdtn)    = F_Rdtn + F_PtfmAM
   
   
   
   
   
END SUBROUTINE WMTOUT_MapOutputs


!====================================================================================================

SUBROUTINE WMTOUT_WriteOutputNames( UnOutFile, p, ErrStat, ErrMsg )

   INTEGER,                      INTENT( IN    ) :: UnOutFile            ! file unit for the output file
   TYPE(WAMIT_ParameterType),    INTENT( IN    ) :: p                    ! WAMIT module's parameter data
   INTEGER,                      INTENT(   OUT ) :: ErrStat              ! returns a non-zero value when an error occurs  
   CHARACTER(*),                 INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None
   
   CHARACTER(200)                                :: Frmt                 ! a string to hold a format statement
   INTEGER                                       :: I                    ! Generic loop counter
   
   ErrStat = ErrID_None
   ErrMsg = ""
   
   Frmt = '(A8,'//TRIM(Int2LStr(p%NumOuts))//'(:,A,'//TRIM( p%OutSFmt )//'))'

   WRITE(UnOutFile,Frmt)  'Time', ( p%Delim, TRIM( p%OutParam(I)%Name ), I=1,p%NumOuts )
      
END SUBROUTINE WMTOUT_WriteOutputNames

!====================================================================================================


SUBROUTINE WMTOUT_WriteOutputUnits( UnOutFile, p, ErrStat, ErrMsg )

   INTEGER,                      INTENT( IN    ) :: UnOutFile            ! file unit for the output file
   TYPE(WAMIT_ParameterType),    INTENT( IN    ) :: p                    ! WAMIT module's parameter data
   INTEGER,                      INTENT(   OUT ) :: ErrStat              ! returns a non-zero value when an error occurs  
   CHARACTER(*),                 INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None
   
   CHARACTER(200)                         :: Frmt                        ! a string to hold a format statement
   INTEGER                                :: I                           ! Generic loop counter
   
   ErrStat = ErrID_None
   ErrMsg = ""
   
   Frmt = '(A8,'//TRIM(Int2LStr(p%NumOuts))//'(:,A,'//TRIM( p%OutSFmt )//'))'

   WRITE(UnOutFile,Frmt)  '(sec)', ( p%Delim, TRIM( p%OutParam(I)%Units ), I=1,p%NumOuts )
      
END SUBROUTINE WMTOUT_WriteOutputUnits

!====================================================================================================
SUBROUTINE WMTOUT_WriteOutputs( UnOutFile, Time, y, p, ErrStat, ErrMsg )
! This subroutine writes the data stored in WriteOutputs (and indexed in OutParam) to the file
! opened in WMTOUT_Init()
!---------------------------------------------------------------------------------------------------- 

      ! Passed variables  
   INTEGER               ,    INTENT( IN    ) :: UnOutFile
   REAL(DbKi),                INTENT( IN    ) :: Time                 ! Time for this output
   TYPE(WAMIT_OutputType),    INTENT( INOUT ) :: y                    ! WAMIT's output data
   TYPE(WAMIT_ParameterType), INTENT( IN    ) :: p                    ! WAMIT parameter data
   INTEGER,                   INTENT(   OUT ) :: ErrStat              ! returns a non-zero value when an error occurs  
   CHARACTER(*),              INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None
   
      ! Local variables
!   REAL(ReKi)                             :: OutData (0:p%NumOuts)       ! an output array
   INTEGER                                :: I                           ! Generic loop counter
   CHARACTER(200)                         :: Frmt                        ! a string to hold a format statement
   

  
      ! Initialize ErrStat and determine if it makes any sense to write output
      
   IF ( .NOT. ALLOCATED( p%OutParam ) .OR. UnOutFile < 0 )  THEN
      ErrMsg  = '  No WAMIT outputs written.  The OutParam array must be allocated and there must be a valid output file identifier before we can write outputs.'
      ErrStat = ErrID_Warn
      RETURN
   ELSE
      ErrStat = ErrID_None
      ErrMsg  = ''
   END IF


 


      ! Write the output parameters to the file
      
   Frmt = '(F8.3,'//TRIM(Int2LStr(p%NumOuts))//'(:,A,'//TRIM( p%OutFmt )//'))'
   !Frmt = '('//TRIM( p%OutFmt )//','//TRIM(Int2LStr(p%NumOuts))//'(:,A,'//TRIM( p%OutFmt )//'))'

   WRITE(UnOutFile,Frmt)  Time, ( p%Delim, y%WriteOutput(I), I=1,p%NumOuts )

   
   RETURN


END SUBROUTINE WMTOUT_WriteOutputs



!====================================================================================================
SUBROUTINE WMTOUT_Init( InitInp, y,  p, InitOut, ErrStat, ErrMsg )
! This subroutine initialized the output module, checking if the output parameter list (OutList)
! contains valid names, and opening the output file if there are any requested outputs
!----------------------------------------------------------------------------------------------------

   

      ! Passed variables

   
   TYPE(WAMIT_InitInputType ), INTENT( IN    ) :: InitInp              ! data needed to initialize the output module     
   TYPE(WAMIT_OutputType),     INTENT( INOUT ) :: y                    ! This module's internal data
   TYPE(WAMIT_ParameterType),  INTENT( INOUT ) :: p 
   TYPE(WAMIT_InitOutputType), INTENT(   OUT ) :: InitOut
   INTEGER,                    INTENT(   OUT ) :: ErrStat              ! a non-zero value indicates an error occurred           
   CHARACTER(*),               INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None
   
      ! Local variables
   INTEGER                                        :: I                    ! Generic loop counter      
!   INTEGER                                        :: J                    ! Generic loop counter      
!   INTEGER                                        :: Indx                 ! Counts the current index into the WaveKinNd array
!   CHARACTER(1024)                                ::  OutFileName         ! The name of the output file  including the full path.
!   CHARACTER(200)                                 :: Frmt                 ! a string to hold a format statement
   
   !-------------------------------------------------------------------------------------------------      
   ! Initialize local variables
   !-------------------------------------------------------------------------------------------------      
     
         
   ErrStat = ErrID_None         
   ErrMsg  = ""  
      
  


   !-------------------------------------------------------------------------------------------------      
   ! Check that the variables in OutList are valid      
   !-------------------------------------------------------------------------------------------------      
      
   
   CALL WMTOUT_ChkOutLst( InitInp%OutList(1:p%NumOuts), y, p, ErrStat, ErrMsg )
   IF ( ErrStat /= 0 ) RETURN
   
   
  IF ( ALLOCATED( p%OutParam ) .AND. p%NumOuts > 0 ) THEN           ! Output has been requested so let's open an output file            
      
      ALLOCATE( y%WriteOutput( p%NumOuts ),  STAT = ErrStat )
      IF ( ErrStat /= ErrID_None ) THEN
         ErrMsg  = ' Error allocating space for WriteOutput array.'
         ErrStat = ErrID_Fatal
         RETURN
      END IF
      y%WriteOutput = 0.0_ReKi
      
        ALLOCATE ( InitOut%WriteOutputHdr(p%NumOuts), STAT = ErrStat )
      IF ( ErrStat /= ErrID_None ) THEN
         ErrMsg  = ' Error allocating space for WriteOutputHdr array.'
         ErrStat = ErrID_Fatal
         RETURN
      END IF
      
      ALLOCATE ( InitOut%WriteOutputUnt(p%NumOuts), STAT = ErrStat )
      IF ( ErrStat /= ErrID_None ) THEN
         ErrMsg  = ' Error allocating space for WriteOutputHdr array.'
         ErrStat = ErrID_Fatal
         RETURN
      END IF   
 
      DO I = 1,p%NumOuts
         
         InitOut%WriteOutputHdr(I) = TRIM( p%OutParam(I)%Name  )
         InitOut%WriteOutputUnt(I) = TRIM( p%OutParam(I)%Units )      
      
      END DO   
      
   END IF   ! there are any requested outputs   

   RETURN

END SUBROUTINE WMTOUT_Init


!====================================================================================================
FUNCTION   GetWAMITChannels    ( NUserOutputs, UserOutputs, OutList, foundMask, ErrStat, ErrMsg )
! This routine checks the names of inputted output channels, checks to see if they
! below to the list of available WAMIT channels.

!----------------------------------------------------------------------------------------------------    
   INTEGER,                       INTENT( IN    ) :: NUserOutputs         ! Number of user-specified output channels
   CHARACTER(10),                 INTENT( IN    ) :: UserOutputs (:)      ! An array holding the names of the requested output channels.
   CHARACTER(10),                 INTENT(   OUT ) :: OutList (:)          ! An array holding the names of the matched WAMIT output channels. 
   LOGICAL,                       INTENT( INOUT ) :: foundMask (:)        ! A mask indicating whether a user requested channel belongs to a module's output channels.
   INTEGER,                       INTENT(   OUT ) :: ErrStat              ! a non-zero value indicates an error occurred           
   CHARACTER(*),                  INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None

   INTEGER                                           GetWAMITChannels     ! The number of channels found in this module

   ! Local variables.
   
   INTEGER                                :: I                                         ! Generic loop-counting index.
   INTEGER                                :: count                                     ! Generic loop-counting index.
   INTEGER                                :: INDX                                      ! Index for valid arrays
   
   CHARACTER(10)                          :: OutListTmp                                ! A string to temporarily hold OutList(I).
   CHARACTER(28), PARAMETER               :: OutPFmt   = "( I4, 3X,A 10,1 X, A10 )"    ! Output format parameter output list.
!   LOGICAL                                :: InvalidOutput(MaxWAMITOutputs)                        ! This array determines if the output channel is valid for this configuration
   LOGICAL                                :: CheckOutListAgain
  
   LOGICAL                                :: newFoundMask (NUserOutputs)              ! A Mask indicating whether a user requested channel belongs to a modules output channels.
  
       ! Initialize ErrStat
         
   ErrStat = ErrID_None         
   ErrMsg  = "" 
   GetWAMITChannels = 0
   
   newFoundMask   =  .FALSE.


    DO I = 1,NUserOutputs
      IF (.NOT. foundMask(I) ) THEN
      OutListTmp         = UserOutputs(I)
!      foundMask(I)       = .FALSE.
      CheckOutListAgain  = .FALSE.
      
      ! Reverse the sign (+/-) of the output channel if the user prefixed the
      !   channel name with a '-', '_', 'm', or 'M' character indicating "minus".
      
      
      
      IF      ( INDEX( '-_', OutListTmp(1:1) ) > 0 ) THEN
        
         OutListTmp                   = OutListTmp(2:)
      ELSE IF ( INDEX( 'mM', OutListTmp(1:1) ) > 0 ) THEN ! We'll assume this is a variable name for now, (if not, we will check later if OutListTmp(2:) is also a variable name)
         CheckOutListAgain            = .TRUE.
         
      END IF
      
      CALL Conv2UC( OutListTmp )    ! Convert OutListTmp to upper case
   
   
      Indx =  IndexCharAry( OutListTmp(1:9), ValidParamAry )
      
      IF ( CheckOutListAgain .AND. Indx < 1 ) THEN    ! Let's assume that "M" really meant "minus" and then test again         
           ! ex, 'MTipDxc1' causes the sign of TipDxc1 to be switched.
         OutListTmp                   = OutListTmp(2:)
         
         Indx = IndexCharAry( OutListTmp(1:9), ValidParamAry )         
      END IF
      
      IF ( Indx > 0 ) THEN     
            newfoundMask(I) = .TRUE.
            foundMask(I) = .TRUE.
            GetWAMITChannels = GetWAMITChannels + 1
        
      !ELSE
      !   foundMask(I) = .FALSE.           
      END IF
    END IF  
END DO

 
IF ( GetWAMITChannels > 0 ) THEN
   
   count = 1
   ! Test that num channels does not exceed max possible channels due to size of OutList
   !ALLOCATE ( OutList(GetWAMITChannels) , STAT=ErrStat )
   IF ( ErrStat /= 0 )  THEN
      ErrMsg  = ' Error allocating memory for the OutList array in the GetWAMITChannels function.'
      ErrStat = ErrID_Fatal
      RETURN
   END IF
   
   DO I = 1,NUserOutputs
      IF ( newfoundMask(I) ) THEN
         OutList(count) = UserOutputs(I)
         count = count + 1
      END IF
      
   END DO
   
END IF

END FUNCTION GetWAMITChannels


!====================================================================================================
SUBROUTINE WMTOUT_ChkOutLst( OutList, y, p, ErrStat, ErrMsg )
! This routine checks the names of inputted output channels, checks to see if any of them are ill-
! conditioned (returning an error if so), and assigns the OutputDataType settings (i.e, the index,  
! name, and units of the output channels). 
! Note that the Wamit module must be initialized prior to calling this function (if it
! is being used) so that it can correctly determine if the Lines outputs are valid.
!----------------------------------------------------------------------------------------------------    
   
   
   
      ! Passed variables
      
   TYPE(WAMIT_OutputType),        INTENT( INOUT ) :: y                                ! This module's internal data
   TYPE(WAMIT_ParameterType),     INTENT( INOUT ) :: p                                   ! parameter data for this instance of the WAMIT platform module   
   CHARACTER(10),                 INTENT( IN    ) :: OutList (:)                               ! An array holding the names of the requested output channels.         
   INTEGER,                       INTENT(   OUT ) :: ErrStat              ! a non-zero value indicates an error occurred           
   CHARACTER(*),                  INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None
   
      ! Local variables.
   
   INTEGER                                :: I                                         ! Generic loop-counting index.
!   INTEGER                                :: J                                         ! Generic loop-counting index.
   INTEGER                                :: INDX                                      ! Index for valid arrays
   
   CHARACTER(10)                          :: OutListTmp                                ! A string to temporarily hold OutList(I).
   CHARACTER(28), PARAMETER               :: OutPFmt   = "( I4, 3X,A 10,1 X, A10 )"    ! Output format parameter output list.
   
   
   ! NOTE: The following lines of code were generated by a Matlab script called "Write_ChckOutLst.m"
!      using the parameters listed in the "OutListParameters.xlsx" Excel file. Any changes to these 
!      lines should be modified in the Matlab script and/or Excel worksheet as necessary. 
! This code was generated by Write_ChckOutLst.m at 09-Jan-2013 14:53:03.
  
   LOGICAL                  :: InvalidOutput(MaxWAMITOutputs)                        ! This array determines if the output channel is valid for this configuration

   LOGICAL                  :: CheckOutListAgain
   
      ! Initialize ErrStat
         
   ErrStat = ErrID_None         
   ErrMsg  = "" 
   
   InvalidOutput            = .FALSE.

!End of code generated by Matlab script
   
   !-------------------------------------------------------------------------------------------------
   ! ALLOCATE the OutParam array
   !-------------------------------------------------------------------------------------------------    
   ALLOCATE ( p%OutParam(p%NumOuts) , STAT=ErrStat )
   IF ( ErrStat /= 0 )  THEN
      ErrMsg  = ' Error allocating memory for the OutParam array.'
      ErrStat = ErrID_Fatal
      RETURN
   END IF
     
   
         
     
   DO I = 1,p%NumOuts
   
      p%OutParam(I)%Name = OutList(I)   
      OutListTmp         = OutList(I)
   
   
      ! Reverse the sign (+/-) of the output channel if the user prefixed the
      !   channel name with a '-', '_', 'm', or 'M' character indicating "minus".
      
      CheckOutListAgain = .FALSE.
      
      IF      ( INDEX( '-_', OutListTmp(1:1) ) > 0 ) THEN
         p%OutParam(I)%SignM = -1     ! ex, '-TipDxc1' causes the sign of TipDxc1 to be switched.
         OutListTmp                   = OutListTmp(2:)
      ELSE IF ( INDEX( 'mM', OutListTmp(1:1) ) > 0 ) THEN ! We'll assume this is a variable name for now, (if not, we will check later if OutListTmp(2:) is also a variable name)
         CheckOutListAgain            = .TRUE.
         p%OutParam(I)%SignM = 1
      ELSE
         p%OutParam(I)%SignM = 1
      END IF
      
      CALL Conv2UC( OutListTmp )    ! Convert OutListTmp to upper case
   
   
      Indx =  IndexCharAry( OutListTmp(1:9), ValidParamAry )
      
      IF ( CheckOutListAgain .AND. Indx < 1 ) THEN    ! Let's assume that "M" really meant "minus" and then test again         
         p%OutParam(I)%SignM = -1            ! ex, 'MTipDxc1' causes the sign of TipDxc1 to be switched.
         OutListTmp                   = OutListTmp(2:)
         
         Indx = IndexCharAry( OutListTmp(1:9), ValidParamAry )         
      END IF
      
      IF ( Indx > 0 ) THEN
         p%OutParam(I)%Indx = ParamIndxAry(Indx)
         IF ( InvalidOutput( ParamIndxAry(Indx) ) ) THEN
            p%OutParam(I)%Units = 'INVALID' 
            p%OutParam(I)%Indx  =  1
            p%OutParam(I)%SignM =  0           
         ELSE
            p%OutParam(I)%Units = ParamUnitsAry(Indx)
         END IF
      ELSE
         ErrMsg  = p%OutParam(I)%Name//' is not an available output channel.'
         ErrStat = ErrID_Fatal
!         RETURN
         p%OutParam(I)%Units = 'INVALID'  
         p%OutParam(I)%Indx  =  1
         p%OutParam(I)%SignM =  0                              ! this will print all zeros
      END IF
      
   END DO
   
 
   RETURN
END SUBROUTINE WMTOUT_ChkOutLst


!====================================================================================================
SUBROUTINE WMTOUT_DestroyParam ( p, ErrStat, ErrMsg )
! This function cleans up after running the WAMIT output module. It closes the output file,
! releases memory, and resets the number of outputs requested to 0.
!----------------------------------------------------------------------------------------------------

         ! Passed variables

   TYPE(WAMIT_ParameterType),     INTENT( INOUT ) :: p                    ! parameter data for this instance of the WAMIT module        
   INTEGER,                       INTENT(   OUT ) :: ErrStat              ! a non-zero value indicates an error occurred           
   CHARACTER(*),                  INTENT(   OUT ) :: ErrMsg               ! Error message if ErrStat /= ErrID_None

!      ! Internal variables
   LOGICAL                               :: Err


   !-------------------------------------------------------------------------------------------------
   ! Initialize error information
   !-------------------------------------------------------------------------------------------------
   ErrStat = ErrID_None
   ErrMsg  = ""
   Err     = .FALSE.

  

   !-------------------------------------------------------------------------------------------------
   ! Deallocate arrays
   !-------------------------------------------------------------------------------------------------
   IF ( ALLOCATED( p%OutParam ) ) DEALLOCATE ( p%OutParam, STAT=ErrStat )
   IF ( ErrStat /= 0 ) Err = .TRUE.
     
   !-------------------------------------------------------------------------------------------------
   ! Reset number of outputs
   !-------------------------------------------------------------------------------------------------
   p%NumOuts   =  0
   p%UnOutFile = -1
   
   !p%WaveKinNd = -1        ! set this array to "invalid"

   !-------------------------------------------------------------------------------------------------
   ! Make sure ErrStat is non-zero if an error occurred
   !-------------------------------------------------------------------------------------------------
   IF ( Err ) ErrStat = ErrID_Fatal
   
   RETURN

END SUBROUTINE WMTOUT_DestroyParam
!====================================================================================================


END MODULE WAMIT_Output
