################################################################################
#
# rockchip-mali-nvr
#
################################################################################

ROCKCHIP_MALI_NVR_VERSION = master
ROCKCHIP_MALI_NVR_SITE = $(TOPDIR)/../external/libmali
ROCKCHIP_MALI_NVR_SITE_METHOD = local
ROCKCHIP_MALI_NVR_LICENSE = ARM
ROCKCHIP_MALI_NVR_LICENSE_FILES = END_USER_LICENCE_AGREEMENT.txt
ROCKCHIP_MALI_NVR_ADD_TOOLCHAIN_DEPENDENCY = NO
ROCKCHIP_MALI_NVR_INSTALL_STAGING = YES

ROCKCHIP_MALI_NVR_SRC = \
	$(BR2_PACKAGE_ROCKCHIP_MALI_NVR_OPTIMIZE)/$(BR2_PACKAGE_ROCKCHIP_MALI_NVR_ARCH_DIR)/$(BR2_PACKAGE_ROCKCHIP_MALI_NVR_NAME)

ROCKCHIP_MALI_NVR_LINKS = \
	$(BR2_PACKAGE_ROCKCHIP_MALI_NVR_NAME) libmali.so libMali.so
ROCKCHIP_MALI_NVR_HEADERS = KHR
ROCKCHIP_MALI_NVR_PKG =

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_NVR_HAS_EGL),y)
ROCKCHIP_MALI_NVR_PROVIDES += libegl
ROCKCHIP_MALI_NVR_LINKS += libEGL.so.1 libEGL.so
ROCKCHIP_MALI_NVR_HEADERS += EGL
ROCKCHIP_MALI_NVR_PKG += egl
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_NVR_HAS_GBM),y)
ROCKCHIP_MALI_NVR_PROVIDES += libgbm
ROCKCHIP_MALI_NVR_LINKS += libgbm.so.1 libgbm.so
ROCKCHIP_MALI_NVR_HEADERS += GBM
ROCKCHIP_MALI_NVR_PKG += gbm
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_NVR_HAS_GLES),y)
ROCKCHIP_MALI_NVR_PROVIDES += libgles
ROCKCHIP_MALI_NVR_LINKS += \
	libGLESv2.so.2 libGLESv2.so libGLESv1_CM.so.1 libGLESv1_CM.so
ROCKCHIP_MALI_NVR_HEADERS += GLES GLES2 GLES3
ROCKCHIP_MALI_NVR_PKG += glesv2 glesv1_cm
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_NVR_HAS_OPENCL),y)
ROCKCHIP_MALI_NVR_PROVIDES += libopencl
ROCKCHIP_MALI_NVR_LINKS += libOpenCL.so.1 libOpenCL.so
ROCKCHIP_MALI_NVR_HEADERS += CL
ROCKCHIP_MALI_NVR_PKG += OpenCL
endif

define ROCKCHIP_MALI_NVR_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0755 $(@D)/$(ROCKCHIP_MALI_NVR_SRC) \
		$(STAGING_DIR)/usr/lib/libmali.so.1

	for l in $(ROCKCHIP_MALI_NVR_LINKS); do \
		ln -sf libmali.so.1 $(STAGING_DIR)/usr/lib/$$l; \
	done

	cd $(@D)/include && \
		cp -rp $(ROCKCHIP_MALI_NVR_HEADERS) $(STAGING_DIR)/usr/include/

	for p in $(ROCKCHIP_MALI_NVR_PKG); do \
		$(INSTALL) -D -m 0644 $(ROCKCHIP_MALI_NVR_PKGDIR)/$$p.pc \
			$(STAGING_DIR)/usr/lib/pkgconfig/$$p.pc; \
	done
endef

define ROCKCHIP_MALI_NVR_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/$(ROCKCHIP_MALI_NVR_SRC) \
		$(TARGET_DIR)/usr/lib/libmali.so.1

	for l in $(ROCKCHIP_MALI_NVR_LINKS); do \
		ln -sf libmali.so.1 $(TARGET_DIR)/usr/lib/$$l; \
	done
endef

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_NVR_G610),y)
define ROCKCHIP_MALI_NVR_INSTALL_G610_FIRMWARE
	$(INSTALL) -D -m 0644 $(@D)/firmware/g610/mali_csffw.bin \
		-t $(TARGET_DIR)/lib/firmware/
endef
ROCKCHIP_MALI_NVR_POST_INSTALL_TARGET_HOOKS += \
	ROCKCHIP_MALI_NVR_INSTALL_G610_FIRMWARE
endif

$(eval $(generic-package))
