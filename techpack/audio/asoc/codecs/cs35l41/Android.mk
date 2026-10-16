# Android makefile for audio kernel modules
#
# Cirrus Logic CS35L41 扬声器功放（TB-J716F 的 4 颗 I2C smart amplifier）
#
# 模块名必须叫 audio_cirrus_cs35l41.ko：原厂固件里就是这个名字，
# DT 的 sound 节点 asoc-codec-names 也引用 cs35l41_1..4，
# 且 modules.dep 里 audio_cirrus_cs35l41.ko 依赖 audio_cirrus_wm_adsp.ko。
# 本模块把 wm_adsp 一起编进来（见 Kbuild），故不再单独产出 wm_adsp.ko。

# Check if this driver needs be built for current target
ifeq ($(call is-board-platform,kona),true)
AUDIO_SELECT  := CONFIG_SND_SOC_KONA=m
endif

AUDIO_CHIPSET := audio
# Build/Package only in case of supported target
ifeq ($(call is-board-platform-in-list, kona),true)

LOCAL_PATH := $(call my-dir)

# This makefile is only for DLKM
ifneq ($(findstring vendor,$(LOCAL_PATH)),)

ifneq ($(findstring opensource,$(LOCAL_PATH)),)
	AUDIO_BLD_DIR := $(shell pwd)/vendor/qcom/opensource/audio-kernel
endif # opensource

DLKM_DIR := $(TOP)/device/qcom/common/dlkm

###########################################################
# This is set once per LOCAL_PATH, not per (kernel) module
KBUILD_OPTIONS := AUDIO_ROOT=$(AUDIO_BLD_DIR)

KBUILD_OPTIONS += MODNAME=cs35l41_dlkm
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
KBUILD_OPTIONS += $(AUDIO_SELECT)

###########################################################
# wm_adsp：提供 wm_adsp2_*/wm_halo_*/wm_adsp_read_ctl 等符号。
# 必须先于 cs35l41 加载（设备端 init.target.rc 已按此顺序 insmod）。
include $(CLEAR_VARS)
LOCAL_MODULE              := $(AUDIO_CHIPSET)_cirrus_wm_adsp.ko
LOCAL_MODULE_KBUILD_NAME  := wm_adsp_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/AndroidKernelModule.mk
###########################################################
# CS35L41 本体（4 颗 I2C 智能功放）
include $(CLEAR_VARS)
LOCAL_MODULE              := $(AUDIO_CHIPSET)_cirrus_cs35l41.ko
LOCAL_MODULE_KBUILD_NAME  := cs35l41_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/AndroidKernelModule.mk
###########################################################

endif # DLKM check
endif # supported target check
