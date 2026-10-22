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

KBUILD_OPTIONS += MODNAME=audio_cirrus_cs35l41
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
KBUILD_OPTIONS += $(AUDIO_SELECT)

###########################################################
# 模块目标名与固件一致，直接由 Kbuild 产出（见 Kbuild 末尾注释）：
#   audio_cirrus_wm_adsp.ko  提供 wm_adsp2_*/wm_halo_*/wm_adsp_read_ctl 等符号
#   audio_cirrus_cs35l41.ko  CS35L41 本体，运行时依赖上面那个
# 加载顺序（设备端 init.target.rc）也与此一致：先 wm_adsp 后 cs35l41。
###########################################################
# wm_adsp（符号提供者）
include $(CLEAR_VARS)
LOCAL_MODULE              := $(AUDIO_CHIPSET)_cirrus_wm_adsp.ko
LOCAL_MODULE_KBUILD_NAME  := audio_cirrus_wm_adsp.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/AndroidKernelModule.mk
###########################################################
# CS35L41 本体（4 颗 I2C 智能功放）
include $(CLEAR_VARS)
LOCAL_MODULE              := $(AUDIO_CHIPSET)_cirrus_cs35l41.ko
LOCAL_MODULE_KBUILD_NAME  := audio_cirrus_cs35l41.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/AndroidKernelModule.mk
###########################################################

endif # DLKM check
endif # supported target check
